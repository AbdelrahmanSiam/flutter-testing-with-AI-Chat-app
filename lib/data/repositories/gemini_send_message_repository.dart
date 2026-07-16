import '../../models/chat_message_model.dart';

/// Repository contract for sending chat messages to Gemini.
abstract class GeminiSendMessageRepository {
  Future<ChatMessageModel> geminiSendMessage(List<ChatMessageModel> messages);
}
