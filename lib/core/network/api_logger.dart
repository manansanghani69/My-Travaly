import 'dart:convert';
import 'dart:developer' as developer;

class ApiLogger {
  ApiLogger._();

  static const _sensitiveHeaders = <String>{
    'authorization',
    'authtoken',
    'visitortoken',
    'x-api-key',
  };

  static void logRequest({
    required Uri url,
    required String action,
    required Map<String, String> headers,
    required Map<String, dynamic> body,
  }) {
    final sanitizedHeaders = _sanitizeHeaders(headers);
    final formattedBody = _formatJson(body);
    final message = StringBuffer()
      ..writeln('>> [$action] POST $url')
      ..writeln('  headers: $sanitizedHeaders')
      ..writeln('  body: $formattedBody');

    developer.log(
      message.toString(),
      name: 'API',
      level: 800, // info
    );
  }

  static void logResponse({
    required Uri url,
    required String action,
    required int statusCode,
    required Duration duration,
    required String body,
    required bool success,
  }) {
    final formattedBody = _tryFormatJsonString(body);
    final prefix = success ? '<<' : '!!';
    final message = StringBuffer()
      ..writeln(
        '$prefix [$action] $statusCode '
        '(${duration.inMilliseconds} ms) from $url',
      )
      ..writeln('  response: $formattedBody');

    developer.log(message.toString(), name: 'API', level: success ? 800 : 1000);
  }

  static void logError({
    required Uri url,
    required String action,
    required Object error,
  }) {
    final message = StringBuffer()
      ..writeln('!! [$action] Network error from $url')
      ..writeln('  error: $error');

    developer.log(message.toString(), name: 'API', level: 1000, error: error);
  }

  static Map<String, String> _sanitizeHeaders(Map<String, String> headers) {
    return headers.map((key, value) {
      if (_sensitiveHeaders.contains(key.toLowerCase())) {
        return MapEntry(key, _mask(value));
      }
      return MapEntry(key, value);
    });
  }

  static String _mask(String value) {
    if (value.isEmpty) {
      return value;
    }
    if (value.length <= 4) {
      return '*' * value.length;
    }
    final start = value.substring(0, 3);
    final end = value.substring(value.length - 3);
    return '$start***$end';
  }

  static String _formatJson(Map<String, dynamic> body) {
    try {
      return const JsonEncoder.withIndent('  ').convert(body);
    } catch (_) {
      return body.toString();
    }
  }

  static String _tryFormatJsonString(String body) {
    try {
      final decoded = jsonDecode(body);
      return const JsonEncoder.withIndent('  ').convert(decoded);
    } catch (_) {
      return body;
    }
  }
}
