import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_logger.dart';
import '../../../../core/utils/device_info_helper.dart';
import '../../domain/usecases/get_search_results.dart';
import '../models/hotel_model.dart';
import '../models/search_autocomplete_model.dart';

abstract class HotelRemoteDataSource {
  Future<String> registerDevice();
  Future<List<HotelModel>> getPopularStays({
    required String city,
    required String state,
    required String country,
  });
  Future<List<SearchSuggestionModel>> searchAutocomplete(String query);
  Future<List<HotelModel>> getSearchResults(SearchParams params);
}

class HotelRemoteDataSourceImpl implements HotelRemoteDataSource {
  HotelRemoteDataSourceImpl({required http.Client client}) : _client = client;

  final http.Client _client;
  String? _visitorToken;

  static final Uri _endpoint = Uri.parse(ApiConstants.baseUrl);

  @override
  Future<String> registerDevice() async {
    if (_visitorToken?.isNotEmpty == true) {
      return _visitorToken!;
    }

    final deviceInfo = await DeviceInfoHelper.getDeviceInfo();
    final payload = _buildDeviceRegisterPayload(deviceInfo);

    final response = await _post(
      action: _Actions.deviceRegister,
      payload: payload,
      includeVisitorToken: false,
      retryOnUnauthorized: false,
    );

    final data = _asMap(response['data']);
    final visitorToken =
        (data['visitorToken'] ??
                data['VisitorToken'] ??
                (data['token'] is Map<String, dynamic>
                    ? (data['token'] as Map<String, dynamic>)['visitorToken']
                    : null))
            ?.toString();

    if (visitorToken == null || visitorToken.isEmpty) {
      throw ServerException('Visitor token missing in response');
    }

    _visitorToken = visitorToken;
    return visitorToken;
  }

  @override
  Future<List<HotelModel>> getPopularStays({
    required String city,
    required String state,
    required String country,
  }) async {
    await _ensureVisitorToken();

    final response = await _post(
      action: _Actions.popularStay,
      payload: <String, dynamic>{
        'limit': 10,
        'entityType': 'Any',
        'filter': <String, dynamic>{
          'searchType': 'byCity',
          'searchTypeInfo': <String, dynamic>{
            'country': country,
            'state': state,
            'city': city,
          },
        },
        'currency': 'INR',
      },
    );

    final list = _extractList(response);
    return list.map(HotelModel.fromJson).toList();
  }

  @override
  Future<List<SearchSuggestionModel>> searchAutocomplete(String query) async {
    if (query.trim().length < 3) {
      return <SearchSuggestionModel>[];
    }

    await _ensureVisitorToken();

    final response = await _post(
      action: _Actions.searchAutoComplete,
      payload: <String, dynamic>{
        'inputText': query,
        'searchType': const [
          'byCity',
          'byState',
          'byCountry',
          'byPropertyName',
        ],
        'limit': 10,
      },
    );

    final suggestions = _parseAutocompleteResponse(response);
    if (suggestions.isEmpty) {
      final list = _extractList(response);
      return list.map(SearchSuggestionModel.fromJson).toList();
    }
    return suggestions.map(SearchSuggestionModel.fromJson).toList();
  }

  @override
  Future<List<HotelModel>> getSearchResults(SearchParams params) async {
    await _ensureVisitorToken();

    final criteria = <String, dynamic>{
      'searchType': params.searchType,
      'searchQuery': params.searchQuery,
      'checkIn': params.checkIn,
      'checkOut': params.checkOut,
      'rooms': params.rooms,
      'adults': params.adults,
      'children': params.children,
      'limit': params.limit,
      'offset': params.offset,
      'accommodation': params.accommodation,
      'arrayOfExcludedSearchType': params.excludedSearchTypes,
      'preloaderList': params.excludedPropertyCodes,
      'currency': params.currency,
      'lowPrice': params.lowPrice,
      'highPrice': params.highPrice,
      'rid': params.requestId,
    }..removeWhere((_, value) => value == null);

    final response = await _post(
      action: _Actions.searchResults,
      payload: <String, dynamic>{'searchCriteria': criteria},
    );

    final list = _extractList(response);
    return list.map(HotelModel.fromJson).toList();
  }

  Future<void> _ensureVisitorToken() async {
    if (_visitorToken?.isNotEmpty == true) {
      return;
    }
    await registerDevice();
  }

  Future<Map<String, dynamic>> _post({
    required String action,
    required Map<String, dynamic> payload,
    bool includeVisitorToken = true,
    bool retryOnUnauthorized = true,
  }) async {
    final headers = ApiConstants.getHeaders(
      visitorToken: includeVisitorToken ? _visitorToken : null,
    );

    final requestPayload = <String, dynamic>{'action': action, action: payload};
    final body = jsonEncode(requestPayload);

    ApiLogger.logRequest(
      url: _endpoint,
      action: action,
      headers: headers,
      body: requestPayload,
    );

    final stopwatch = Stopwatch()..start();
    http.Response response;
    try {
      response = await _client.post(_endpoint, headers: headers, body: body);
    } catch (error) {
      stopwatch.stop();
      ApiLogger.logError(url: _endpoint, action: action, error: error);
      rethrow;
    }
    stopwatch.stop();

    Map<String, dynamic> decoded;
    try {
      decoded = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      ApiLogger.logResponse(
        url: _endpoint,
        action: action,
        statusCode: response.statusCode,
        duration: stopwatch.elapsed,
        body: response.body,
        success: false,
      );
      throw ServerException('Invalid response from server');
    }

    final isSuccess = _isSuccessResponse(response.statusCode, decoded);

    ApiLogger.logResponse(
      url: _endpoint,
      action: action,
      statusCode: response.statusCode,
      duration: stopwatch.elapsed,
      body: response.body,
      success: isSuccess,
    );

    if (isSuccess) {
      return decoded;
    }

    final message = decoded['message']?.toString() ?? 'Request failed';
    final responseCode =
        decoded['responseCode'] as int? ??
        decoded['statusCode'] as int? ??
        response.statusCode;

    if (includeVisitorToken &&
        retryOnUnauthorized &&
        (response.statusCode == 401 ||
            responseCode == 401 ||
            message.toLowerCase().contains('visitortoken'))) {
      _visitorToken = null;
      await registerDevice();
      return _post(
        action: action,
        payload: payload,
        includeVisitorToken: includeVisitorToken,
        retryOnUnauthorized: false,
      );
    }

    throw ServerException(message);
  }

  Map<String, dynamic> _buildDeviceRegisterPayload(Map<String, dynamic> info) {
    final deviceInfo = _sanitizeDeviceInfo(info);
    final payload =
        <String, dynamic>{
          'deviceModel': deviceInfo['deviceModel'],
          'deviceFingerprint': deviceInfo['deviceFingerprint'],
          'deviceBrand': deviceInfo['deviceBrand'],
          'deviceId': deviceInfo['deviceId'],
          'deviceName': deviceInfo['deviceName'],
          'deviceManufacturer': deviceInfo['deviceManufacturer'],
          'deviceProduct': deviceInfo['deviceProduct'],
          'deviceSerialNumber': deviceInfo['deviceSerialNumber'],
          if (deviceInfo.containsKey('platform'))
            'platform': deviceInfo['platform'],
          if (deviceInfo.containsKey('osVersion'))
            'deviceOs': deviceInfo['osVersion'],
          'source': 'flutter',
          'appVersion': '1.0.0',
          'packageName': 'com.mytravaly.app',
        }..removeWhere((_, value) {
          if (value == null) {
            return true;
          }
          if (value is String) {
            return value.trim().isEmpty;
          }
          return false;
        });

    return payload;
  }

  Map<String, dynamic> _sanitizeDeviceInfo(Map<String, dynamic> info) {
    String? read(List<Object> keys) {
      for (final key in keys) {
        if (info[key] != null && info[key].toString().isNotEmpty) {
          return info[key].toString();
        }
      }
      return null;
    }

    final fallbackId =
        'flutter-${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(1 << 32)}';

    final primarySerial =
        read([
          'serialNumber',
          'identifierForVendor',
          'deviceSerialNumber',
          'deviceId',
          'machineId',
        ]) ??
        fallbackId;
    final primaryDeviceId =
        read([
          'androidId',
          'deviceId',
          'identifierForVendor',
          'machineId',
          'deviceUUID',
          'id',
        ]) ??
        primarySerial;

    final map =
        <String, dynamic>{
          'deviceModel': read(['model', 'deviceModel', 'device']) ?? 'Unknown',
          'deviceBrand':
              read(['brand', 'deviceBrand', 'manufacturer']) ?? 'Unknown',
          'deviceManufacturer':
              read(['manufacturer', 'deviceManufacturer']) ?? 'Unknown',
          'deviceProduct': read(['product', 'deviceProduct']) ?? '',
          'deviceName': read(['device', 'name', 'computerName']) ?? 'Unknown',
          'deviceFingerprint':
              read(['fingerprint', 'systemGUID', 'buildLab', 'utsname']) ?? '',
          'deviceSerialNumber': primarySerial,
          'deviceId': primaryDeviceId,
          'platform': read(['platform', 'systemName']) ?? 'flutter',
          'osVersion':
              read(['release', 'systemVersion', 'osRelease', 'version']) ?? '',
          'sdkInt': info['sdkInt'],
          'isPhysicalDevice': info['isPhysicalDevice'] ?? true,
        }..removeWhere(
          (key, value) => value == null || (value is String && value.isEmpty),
        );

    return map;
  }

  bool _isSuccessResponse(int statusCode, Map<String, dynamic> body) {
    final status = body['status'];
    final code = body['responseCode'] ?? body['statusCode'];

    if (status is bool && status) {
      return true;
    }
    if (code is int && code >= 200 && code < 300) {
      return true;
    }
    return statusCode >= 200 && statusCode < 300;
  }

  List<Map<String, dynamic>> _extractList(Map<String, dynamic> body) {
    final data = body['data'];
    if (data == null) {
      return <Map<String, dynamic>>[];
    }
    return _asMapList(data);
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return value.map((key, dynamic v) => MapEntry(key.toString(), v));
    }
    throw ServerException('Invalid data format received from server');
  }

  List<Map<String, dynamic>> _asMapList(dynamic value) {
    if (value is List) {
      return value.whereType<Map>().map((item) => _asMap(item)).toList();
    }
    if (value is Map<String, dynamic>) {
      final nested =
          value['data'] ??
          value['results'] ??
          value['items'] ??
          value['popularStay'] ??
          value['searchAutoComplete'] ??
          value['autoCompleteList'] ??
          value['arrayOfHotelList'] ??
          value['hotels'] ??
          value['responseData'] ??
          value['dataList'];
      if (nested != null) {
        return _asMapList(nested);
      }
      return <Map<String, dynamic>>[value];
    }
    if (value is Map) {
      return _asMapList(Map<String, dynamic>.from(value));
    }
    return <Map<String, dynamic>>[];
  }

  List<Map<String, dynamic>> _parseAutocompleteResponse(
    Map<String, dynamic> response,
  ) {
    final data = response['data'];
    if (data == null) {
      return <Map<String, dynamic>>[];
    }

    if (data is List) {
      return _asMapList(data);
    }

    final dataMap = _asMap(data);
    final suggestions = <Map<String, dynamic>>[];

    void collect(dynamic source, {String? category}) {
      final items = _parseAutocompleteCategory(source);
      for (final item in items) {
        final suggestion = Map<String, dynamic>.from(item);
        if (category != null && suggestion['type'] == null) {
          suggestion['type'] = category;
        }
        suggestions.add(suggestion);
      }
    }

    final autoComplete =
        dataMap['autoCompleteList'] ?? dataMap['searchAutoComplete'];
    if (autoComplete is Map) {
      autoComplete.forEach((key, value) {
        collect(value, category: key.toString());
      });
    } else if (autoComplete != null) {
      collect(autoComplete);
    } else if (dataMap.containsKey('listOfResult')) {
      collect(dataMap);
    }

    return suggestions;
  }

  List<Map<String, dynamic>> _parseAutocompleteCategory(dynamic source) {
    if (source is Map<String, dynamic>) {
      final results =
          source['listOfResult'] ??
          source['results'] ??
          source['items'] ??
          source['data'];
      if (results != null) {
        return _asMapList(results);
      }
      if (source.containsKey('valueToDisplay')) {
        return <Map<String, dynamic>>[source];
      }
    } else if (source is List) {
      return _asMapList(source);
    }
    return <Map<String, dynamic>>[];
  }
}

class _Actions {
  static const String deviceRegister = 'deviceRegister';
  static const String popularStay = 'popularStay';
  static const String searchAutoComplete = 'searchAutoComplete';
  static const String searchResults = 'getSearchResultListOfHotels';
}
