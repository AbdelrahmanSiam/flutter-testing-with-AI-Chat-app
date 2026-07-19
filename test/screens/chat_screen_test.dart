/*
                         AI Chat Screen Widget Test
Test cases:
// Initial state: no messages shown   => Ignored because it is available in cubit state
// validation of input message as Unit test (If i have input validation logic)

When the user sends a message, expect a loading bubble to appear.
When the user sends a message and the request succeeds, expect a success bubble to appear.
When the user sends a message and the request fails, expect a failure bubble to appear.
When a failure bubble is shown and the user taps retry, expect a loading bubble to appear and then either:
a success bubble if the retry succeeds, or
a failure bubble if the retry fails.
When a failure bubble is shown and the user sends another message, expect the new message to be accepted and processed.
When a loading bubble is visible, expect the user to be unable to send another message.
 */
import 'package:ai_chat_app/data/repositories/gemini_send_message_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class GeminiSendMessageRepositoryImplMock extends Mock implements GeminiSendMessageRepositoryImpl {}

void main() {
  late GeminiSendMessageRepositoryImplMock mock;
  setUp(() {
    mock = GeminiSendMessageRepositoryImplMock();
  });
}