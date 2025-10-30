class ServerException implements Exception {
  ServerException([this.message]);
  final String? message;

  @override
  String toString() => message != null ? 'ServerException: $message' : 'ServerException';
}

class CacheException implements Exception {
  CacheException([this.message]);
  final String? message;

  @override
  String toString() => message != null ? 'CacheException: $message' : 'CacheException';
}

class NetworkException implements Exception {
  NetworkException([this.message]);
  final String? message;

  @override
  String toString() => message != null ? 'NetworkException: $message' : 'NetworkException';
}

class AuthException implements Exception {
  AuthException([this.message]);
  final String? message;

  @override
  String toString() => message != null ? 'AuthException: $message' : 'AuthException';
}
