import '../../domain/entities/hotel.dart';
import 'property_model.dart';

class HotelModel extends Hotel {
  const HotelModel({
    required super.propertyCode,
    required super.propertyName,
    required super.propertyStar,
    required super.propertyImage,
    required super.propertyType,
    required PropertyAddressModel address,
    required PriceInfoModel markedPrice,
    required PriceInfoModel staticPrice,
    GoogleReviewModel? googleReview,
  }) : super(
         address: address,
         markedPrice: markedPrice,
         staticPrice: staticPrice,
         googleReview: googleReview,
       );

  factory HotelModel.fromJson(Map<String, dynamic> json) {
    String resolveImage() {
      final direct = json['propertyImage'];
      if (direct is String && direct.isNotEmpty) {
        return direct;
      }
      final media =
          json['propertyImage'] as Map<String, dynamic>? ??
          json['media'] as Map<String, dynamic>? ??
          <String, dynamic>{};
      final fullUrl = media['fullUrl'];
      if (fullUrl is String && fullUrl.isNotEmpty) {
        return fullUrl;
      }

      final location = media['location'] as String? ?? '';
      final imageName = media['imageName'] as String? ?? '';
      if (location.isNotEmpty && imageName.isNotEmpty) {
        final normalizedLocation = location.endsWith('/')
            ? location
            : '$location/';
        return '$normalizedLocation$imageName';
      }
      return '';
    }

    return HotelModel(
      propertyCode: json['propertyCode'] as String? ?? '',
      propertyName: json['propertyName'] as String? ?? '',
      propertyStar: (json['propertyStar'] as num?)?.toInt() ?? 0,
      propertyImage: resolveImage(),
      propertyType:
          (json['propertyType'] ??
                  json['propertytype'] ??
                  json['property_type'] ??
                  '')
              .toString(),
      address: PropertyAddressModel.fromJson(
        json['propertyAddress'] as Map<String, dynamic>?,
      ),
      markedPrice: PriceInfoModel.fromJson(
        json['markedPrice'] as Map<String, dynamic>?,
      ),
      staticPrice: PriceInfoModel.fromJson(
        json['staticPrice'] as Map<String, dynamic>?,
      ),
      googleReview: json['googleReview'] != null
          ? GoogleReviewModel.fromJson(
              json['googleReview'] as Map<String, dynamic>?,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'propertyCode': propertyCode,
      'propertyName': propertyName,
      'propertyStar': propertyStar,
      'propertyImage': propertyImage,
      'propertyType': propertyType,
      'propertyAddress': (address as PropertyAddressModel).toJson(),
      'markedPrice': (markedPrice as PriceInfoModel).toJson(),
      'staticPrice': (staticPrice as PriceInfoModel).toJson(),
      'googleReview': googleReview != null
          ? (googleReview as GoogleReviewModel).toJson()
          : null,
    };
  }
}
