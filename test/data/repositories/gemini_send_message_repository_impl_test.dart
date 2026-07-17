// Inputs must be mocks
import 'package:ai_chat_app/data/repositories/gemini_send_message_repository_impl.dart';
import 'package:ai_chat_app/models/chat_message_model.dart';
import 'package:ai_chat_app/models/message_content_model.dart';
import 'package:ai_chat_app/models/message_part_model.dart';
import 'package:ai_chat_app/services/gemini_chat_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

ChatMessageModel _getMessageModelTest() => ChatMessageModel(
  content: MessageContentModel(
    role: 'model',
    parts: [MessagePartModel(text: "test")],
  ),
);

class GeminiChatServiceMock extends Mock implements GeminiChatService {}

void main() {
  late GeminiSendMessageRepositoryImpl repo;
  late GeminiChatServiceMock mock;

  setUp(() {
    repo = GeminiSendMessageRepositoryImpl(service: GeminiChatServiceMock());
    mock = GeminiChatServiceMock();
  });

  group('Test that validation in send message is correct', () {
    test(
      'Test if messages length > 20 then messages length does not change',
      () {
        // Arrange
        when(
          () => mock.sendMessage(any()),
        ).thenAnswer((_) async => _getMessageModelTest());
        // Act
        List<ChatMessageModel> messages = List.generate(
          20,
          (index) => ChatMessageModel(
            content: MessageContentModel(
              role: 'model',
              parts: [MessagePartModel(text: 'text')],
            ),
          ),
        );
        var res = repo.geminiSendMessage(messages);
        var capturedMessages =
            verify(
                  () => mock.sendMessage(captureAny<List<ChatMessageModel>>()),
                ).captured.first
                as List<ChatMessageModel>; // return the parameters
        // Assert
        expect(capturedMessages.length, equals(messages.length));
      },
    );
  });
}
