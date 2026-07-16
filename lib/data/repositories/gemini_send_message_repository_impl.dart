import '../../models/chat_message_model.dart';
import '../../services/gemini_chat_service.dart';
import 'gemini_send_message_repository.dart';

/// Concrete repository implementation for Gemini message sending.
class GeminiSendMessageRepositoryImpl implements GeminiSendMessageRepository {
  GeminiSendMessageRepositoryImpl({required GeminiChatService service}) : _service = service;

  final GeminiChatService _service;

  @override
  Future<ChatMessageModel> geminiSendMessage(List<ChatMessageModel> messages) {
    if(messages.length > 20) {
      messages = messages.sublist(messages.length - 5);
    }
    return _service.sendMessage(messages);
  }
}
