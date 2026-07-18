import 'package:ai_chat_app/models/chat_message_model.dart';
import 'package:ai_chat_app/models/message_content_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'client_api.dart';

/// Service for interacting with Google Gemini API.
class GeminiChatService {
  final ClientApi _api;
  final String _apiKey = dotenv.env["API_KEY"]!;

  GeminiChatService({
    required ClientApi api,
    String modelId = 'gemini-3-flash-preview', // Recommended model
  }) : _api = api;
  final url = dotenv.env["API_URL"]!;

  late DioException exception;
  Future<ChatMessageModel> sendMessage(List<ChatMessageModel> messages) async {
    final requestContents = messages
        .map(
          (message) => {
            'role': message.content.role,
            'parts': message.content.parts.map((p) => p.toJson()).toList(),
          },
        )
        .toList();

    for (int i = 0; i < 3; i++) {
      try {
        final response = await _api.post<Map<String, dynamic>>(
          url,
          data: {'contents': requestContents},
          headers: {
            'x-goog-api-key': _apiKey,
            'Content-Type': 'application/json',
          },
        );
        final data = response.data;
        return ChatMessageModel.fromJson(data!);
      } on DioException catch (e) {
        exception = e;
        if (!isRetryableDioException(e)) {
          rethrow;
        }
        if (i < 2) {
          await Future.delayed(Duration(seconds: i + 1));
        }
      }
    }
    throw exception;
  }

  bool isRetryableDioException(DioException exception) {
    if (exception.type == DioExceptionType.cancel) {
      return false;
    }

    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return true;
      case DioExceptionType.badResponse:
        final statusCode = exception.response?.statusCode;
        if (statusCode == null) {
          return true;
        }
        return statusCode == 429 ||
            statusCode == 408 ||
            (statusCode >= 500 && statusCode < 600);
      case DioExceptionType.unknown:
        return true;
      default:
        return false;
    }
  }
}
