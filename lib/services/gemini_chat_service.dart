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
  }) : _api = api,
       _apiKey = apiKey,
       _modelId = modelId;

  /// Sends a list of chat messages to Gemini and returns the model's response.
  ///
  /// Takes [messages] as a list of chat messages (user and model turns).
  /// Returns a [ChatMessageModel] containing the model's response.
  Future<ChatMessageModel> sendMessage(List<ChatMessageModel> messages) async {
    // Format messages for the API request
    final requestContents = messages
        .map((message) => message.toJson())
        .toList();

    final url = '/v1beta/models/$_modelId:generateContent';

    // Make the POST request
    final response = await _api.post<Map<String, dynamic>>(
      url,
      data: {'contents': requestContents},
      headers: {'x-goog-api-key': _apiKey, 'Content-Type': 'application/json'},
    );

    return ChatMessageModel.fromJson(response.data!);
  }
}
