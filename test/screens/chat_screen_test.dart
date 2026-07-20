/*
                         AI Chat Screen Widget Test
Test cases:
// Initial state: no messages shown   => Ignored because it is available in cubit state
// validation of input message as Unit test (If i have input validation logic)

case 1 : When the user sends a message, expect a loading bubble to appear.
case 2 : When the user sends a message and the request succeeds, expect a success bubble to appear.
case 3 : When the user sends a message and the request fails, expect a failure bubble to appear.
case 4 : When a failure bubble is shown and the user taps retry, expect a loading bubble to appear and then a success bubble if the retry succeeds.
case 5 : When a failure bubble is shown and the user taps retry, expect a loading bubble to appear and then a failure bubble if the retry fails.
case 6 : When a failure bubble is shown and the user sends another message, expect the new message to be accepted and processed.
When a loading bubble is visible, expect the user to be unable to send another message.
 */
import 'package:ai_chat_app/cubit/gemini_send_message/gemini_send_message_cubit.dart';
import 'package:ai_chat_app/data/repositories/gemini_send_message_repository.dart';
import 'package:ai_chat_app/data/repositories/gemini_send_message_repository_impl.dart';
import 'package:ai_chat_app/di/service_locator.dart';
import 'package:ai_chat_app/models/chat_message_model.dart';
import 'package:ai_chat_app/ui/screens/chat_screen.dart';
import 'package:ai_chat_app/ui/widgets/ai_loading_message_bubble.dart';
import 'package:ai_chat_app/ui/widgets/ai_message_bubble.dart';
import 'package:ai_chat_app/ui/widgets/failure_message_bubble.dart';
import 'package:ai_chat_app/ui/widgets/user_message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class GeminiSendMessageRepositoryImplMock extends Mock
    implements GeminiSendMessageRepositoryImpl {}

ChatMessageModel getChatMessageModel() =>
    ChatMessageModel.model('Hello, how can I assist you today?');

void main() {
  late GeminiSendMessageRepositoryImplMock mock;
  setUp(() async {
    mock = GeminiSendMessageRepositoryImplMock();
    await getIt
        .reset(); // To ensure that the service locator is reset before each test and generate a new instance of the cubit with the mock repository.
    getIt.registerSingleton<GeminiSendMessageRepository>(mock);
    getIt.registerFactory<GeminiSendMessageCubit>(
      () => GeminiSendMessageCubit(
        repository: getIt<GeminiSendMessageRepository>(),
      ),
    );
  });

  group('Chat Screen Widgets Test Cases', () {
    testWidgets(
      'Case 1 :When the user sends a message, expect a loading bubble to appear.',
      (tester) async {
        when(() => mock.geminiSendMessage(any())).thenAnswer((_) async {
          await Future.delayed(const Duration(seconds: 2));
          return getChatMessageModel();
        });
        await tester.pumpWidget(MaterialApp(home: const ChatScreen()));
        await tester.pumpAndSettle();
        var textField = find.byKey(const Key("custom_text_field"));
        await tester.enterText(textField, 'Hello');
        await tester.pumpAndSettle();
        var iconButton = find.byIcon(Icons.arrow_upward_rounded);
        await tester.tap(iconButton);
        await tester
            .pump(); // to get one frame to show the loading bubble and then disappear but pumpAndSettle generate frames after each other
        expect(find.byType(AiLoadingMessageBubble), findsOneWidget);
        await tester
            .pumpAndSettle(); // wait for the loading bubble to disappear because the previous is animation.
      },
    );
    testWidgets(
      'Case 2 : When the user sends a message and the request succeeds, expect a success bubble to appear.',
      (tester) async {
        when(() => mock.geminiSendMessage(any())).thenAnswer((_) async {
          await Future.delayed(const Duration(seconds: 2));
          return getChatMessageModel();
        });
        await tester.pumpWidget(MaterialApp(home: const ChatScreen()));
        await tester.pumpAndSettle();
        var textField = find.byKey(const Key("custom_text_field"));
        await tester.enterText(textField, 'Hello');
        await tester.pumpAndSettle();
        var iconButton = find.byIcon(Icons.arrow_upward_rounded);
        await tester.tap(iconButton);
        await tester.pumpAndSettle();
        expect(find.byType(AiMessageBubble), findsOneWidget);
      },
    );
  });
  testWidgets('case 3 : Failure Bubble .', (tester) async {
    when(() => mock.geminiSendMessage(any())).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      throw Exception('Failed to send message');
    });
    await tester.pumpWidget(MaterialApp(home: const ChatScreen()));
    await tester.pumpAndSettle();
    var textField = find.byKey(const Key("custom_text_field"));
    await tester.enterText(textField, 'Hello');
    await tester.pumpAndSettle();
    var iconButton = find.byIcon(Icons.arrow_upward_rounded);
    await tester.tap(iconButton);
    await tester.pumpAndSettle();
    expect(
      find.descendant(
        of: find.byType(FailureMessageBubble),
        matching: find.text('Hello'),
      ),
      findsOneWidget,
    );
  });

  testWidgets(
    'case 4 : Success Retry => When a failure bubble is shown and the user taps retry, expect failure bubble to disappear and replaced with user bubble and then AI success bubble.',
    (tester) async {
      var counter = 0;
      when(() => mock.geminiSendMessage(any())).thenAnswer((_) async {
        counter++;
        await Future.delayed(const Duration(seconds: 2));
        if (counter == 1) {
          throw Exception('Failed to send message');
        }
        return getChatMessageModel();
      });
      await tester.pumpWidget(MaterialApp(home: const ChatScreen()));
      await tester.pumpAndSettle();
      var textField = find.byKey(const Key("custom_text_field"));
      await tester.enterText(textField, 'Hello');
      await tester.pumpAndSettle();
      var iconButton = find.byIcon(Icons.arrow_upward_rounded);
      await tester.tap(iconButton);
      await tester.pumpAndSettle();
      expect(
        find.descendant(
          of: find.byType(FailureMessageBubble),
          matching: find.text('Hello'),
        ),
        findsOneWidget,
      );
      var retryButton = find.byIcon(Icons.refresh);
      await tester.tap(retryButton);
      await tester.pumpAndSettle();
      expect(find.byType(UserMessageBubble), findsOneWidget);
      expect(find.byType(AiMessageBubble), findsOneWidget);
      expect(find.byType(FailureMessageBubble), findsNothing);
    },
  );

    testWidgets(
    'case 5 : Failure Retry => When a failure bubble is shown and the user taps retry, expect failure bubble to disappear and replaced with another failure bubble.',
    (tester) async {
      for(int i =0 ; i < 2 ; i++){
         when(() => mock.geminiSendMessage(any())).thenAnswer((_) async {
        await Future.delayed(const Duration(seconds: 2));
          throw Exception('Failed to send message');
      });
      }
      await tester.pumpWidget(MaterialApp(home: const ChatScreen()));
      await tester.pumpAndSettle();
      var textField = find.byKey(const Key("custom_text_field"));
      await tester.enterText(textField, 'Hello');
      await tester.pumpAndSettle();
      var iconButton = find.byIcon(Icons.arrow_upward_rounded);
      await tester.tap(iconButton);
      await tester.pumpAndSettle();
      expect(
        find.descendant(
          of: find.byType(FailureMessageBubble),
          matching: find.text('Hello'),
        ),
        findsOneWidget,
      );
      var retryButton = find.byIcon(Icons.refresh);
      await tester.tap(retryButton);
      await tester.pumpAndSettle();
      expect(find.byType(UserMessageBubble), findsNothing);
      expect(find.byType(AiMessageBubble), findsNothing);
      expect(find.byType(FailureMessageBubble), findsOneWidget);
    },
  );
}
