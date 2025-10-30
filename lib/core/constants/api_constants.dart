class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://api.mytravaly.com/public/v1/';
  static const String authToken = '71523fdd8d26f585315b4233e39d9263';

  static Map<String, String> getHeaders({String? visitorToken}) {
    final headers = <String, String>{
      'authtoken': authToken,
      'Content-Type': 'application/json',
    };

    if (visitorToken != null && visitorToken.isNotEmpty) {
      headers['visitortoken'] = visitorToken;
    }

    return headers;
  }
}
