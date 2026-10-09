import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final int statusCode;
  final String message;
  ApiException(this.statusCode, this.message);

  @override
  String toString() => 'ApiException: $statusCode - $message';
}

class BaseClient {
  static final http.Client _client = http.Client();
  static Map<String, String> defaultHeaders = {};

  // Unified Request Helper
  static Future<dynamic> _handleRequest(
    Future<http.Response> Function() request,
  ) async {
    try {
      final response = await request();
      final decodedResponse = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return decodedResponse;
      } else {
        throw ApiException(
          response.statusCode,
          decodedResponse['message'] ?? "Server Error: ${response.statusCode}",
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(500, e.toString());
    }
  }

  static Future<dynamic> get(
    String host,
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? query,
  }) async {
    final url = Uri.parse(host).resolve(path).replace(queryParameters: query);
    final mergedHeaders = {
      ...defaultHeaders,
      ...?headers,
    };
    return _handleRequest(() => _client.get(url, headers: mergedHeaders));
  }

  static Future<dynamic> post(
    String host,
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    final url = Uri.parse(host).resolve(path);
    final mergedHeaders = {
      ...defaultHeaders,
      ...?headers,
    };
    return _handleRequest(
      () => _client.post(url, headers: mergedHeaders, body: jsonEncode(body)),
    );
  }

  static Future<dynamic> patch(
    String host,
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    final url = Uri.parse(host).resolve(path);
    final mergedHeaders = {
      ...defaultHeaders,
      ...?headers,
    };
    return _handleRequest(
      () => _client.patch(url, headers: mergedHeaders, body: jsonEncode(body)),
    );
  }
}
