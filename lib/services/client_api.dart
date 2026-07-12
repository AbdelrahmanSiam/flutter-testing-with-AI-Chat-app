import 'package:dio/dio.dart';

class ClientApi {
  final Dio _dio;

  ClientApi({
    String baseUrl = '',
    BaseOptions? options,
  }) : _dio = Dio(options ?? BaseOptions(baseUrl: baseUrl));

  /// Sends a POST request to [path] with optional JSON [data].
  ///
  /// Returns the raw Dio [Response] so callers can handle typed payloads.
  Future<Response<T>> post<T>(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// Sends a POST request with JSON content.
  Future<Response<Map<String, dynamic>>> postJson(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) {
    return _dio.post<Map<String, dynamic>>(
      path,
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
