import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<ConnectivityResult> get onStatusChange;
}

class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl(
    this._connectivity, {
    Duration fallbackTimeout = const Duration(seconds: 3),
  }) : _fallbackTimeout = fallbackTimeout;

  final Connectivity _connectivity;
  final Duration _fallbackTimeout;

  @override
  Future<bool> get isConnected async {
    try {
      final result = await _connectivity.checkConnectivity();
      if (result != ConnectivityResult.none) {
        return true;
      }

      if (kIsWeb) {
        return false;
      }

      final lookup = await InternetAddress.lookup(
        'example.com',
      ).timeout(_fallbackTimeout);
      return lookup.isNotEmpty && lookup.first.rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    } on TimeoutException {
      return false;
    } catch (_) {
      return false;
    }
  }

  @override
  Stream<ConnectivityResult> get onStatusChange =>
      _connectivity.onConnectivityChanged;
}
