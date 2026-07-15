import 'package:ai_chat_app/models/chat_message_model.dart';
import 'package:ai_chat_app/models/message_content_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'client_api.dart';

/// Service for interacting with Google Gemini API.
class GeminiChatService {
  final ClientApi _api;
  final String _apiKey = dotenv.env["API_KEY"]!;

  GeminiChatService({
    required ClientApi api,
    String modelId = 'gemini-3-flash-preview',   // Recommended model
  })  : _api = api;

  Future<ChatMessageModel> sendMessage(List<ChatMessageModel> messages) async {
    final requestContents = messages
        .map((message) => {
              'role': message.content.role,
              'parts': message.content.parts.map((p) => p.toJson()).toList(),
            })
        .toList();

    final url = dotenv.env["API_URL"]!;

    final response = await _api.post<Map<String, dynamic>>(
      url,
      data: {'contents': requestContents},
      headers: {
        'x-goog-api-key': _apiKey,
        'Content-Type': 'application/json',
      },
    );

    final data = response.data;

    if (data == null || data['candidates'] == null || (data['candidates'] as List).isEmpty) {
      throw Exception('No response from Gemini API');
    }

    final candidate = (data['candidates'] as List).first as Map<String, dynamic>;
    final content = candidate['content'] as Map<String, dynamic>?;

    if (content == null) {
      throw Exception('Invalid response format from Gemini');
    }

    // Convert to your model
    return ChatMessageModel(
      content: MessageContentModel.fromJson(content),
      finishReason: candidate['finishReason'] as String?,
      index: candidate['index'] as int?,
    );
  }
}