import 'package:dio/dio.dart';

import '../models/chat_message_model.dart';
import 'client_api.dart';

/// Service for interacting with Google Gemini API.
class GeminiChatService {
  final ClientApi _api;
  final String _apiKey;
  final String _modelId;

  GeminiChatService({
    required ClientApi api,
    required String apiKey,
    String modelId = 'gemini-3-flash-preview',
  })  : _api = api,
        _apiKey = apiKey,
        _modelId = modelId;

  /// Sends a list of chat messages to Gemini and returns the model's response.
  ///
  /// Takes [messages] as a list of chat messages (user and model turns).
  /// Returns a [ChatMessageModel] containing the model's response.
  Future<ChatMessageModel> sendMessage(List<ChatMessageModel> messages) async {
    try {
      // Format messages for the API request
      final requestContents = messages
          .map(
            (msg) => {
              'role': msg.content.role,
              'parts': msg.content.parts
                  .map(
                    (part) => {'text': part.text},
                  )
                  .toList(),
            },
          )
          .toList();

      // Make the POST request
      final response = await _api.post<Map<String, dynamic>>(
        '/v1beta/models/$_modelId:generateContent',
        data: {'contents': requestContents},
        queryParameters: {'key': _apiKey},
      );

      // Parse the response
      if (response.statusCode == 200 && response.data != null) {
        return _parseGeminiResponse(response.data!);
      } else {
        throw Exception('Failed to get response from Gemini API');
      }
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Error sending message to Gemini: $e');
    }
  }

  /// Parses the Gemini API response and extracts the message.
  ChatMessageModel _parseGeminiResponse(Map<String, dynamic> response) {
    try {
      final candidates = response['candidates'] as List?;

      if (candidates == null || candidates.isEmpty) {
        throw Exception('No candidates in response');
      }

      // Get the first candidate
      final candidate = candidates.first as Map<String, dynamic>;

      // Convert to ChatMessageModel
      return ChatMessageModel.fromJson(candidate);
    } catch (e) {
      throw Exception('Error parsing Gemini response: $e');
    }
  }
}
