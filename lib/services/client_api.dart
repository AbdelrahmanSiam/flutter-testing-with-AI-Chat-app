import 'package:dio/dio.dart';

class ClientApi {
  final Dio _dio;
  final String _baseUrl;

 ClientApi({Dio? dio, String? baseUrl})
      : _dio = dio ?? Dio(),
        _baseUrl = baseUrl ?? '';

  /// Sends a POST request to [path] with optional JSON [data].
  ///
  /// Returns the raw Dio [Response] so callers can handle typed payloads.
  Future<Response<T>> post<T>(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) {
    final url = _baseUrl.isEmpty ? path : '$_baseUrl$path';
    return _dio.post<T>(
      url,
      data: data,
      queryParameters: queryParameters,
      options: Options(headers: headers),
    );
  }

  /// Sends a POST request with JSON content.
  Future<Response<Map<String, dynamic>>> postJson(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) {
    final url = _baseUrl.isEmpty ? path : '$_baseUrl$path';
    return _dio.post<Map<String, dynamic>>(
      url,
      data: body,
      queryParameters: queryParameters,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          ...?headers,
        },
      ),
    );
  }

  /// Update the base URL used by this client.
  void updateBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }
}
