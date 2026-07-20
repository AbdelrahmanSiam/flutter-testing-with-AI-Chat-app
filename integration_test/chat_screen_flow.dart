import 'package:ai_chat_app/di/service_locator.dart';
import 'package:ai_chat_app/models/chat_message_model.dart';
import 'package:ai_chat_app/services/client_api.dart';
import 'package:ai_chat_app/ui/screens/chat_screen.dart';
import 'package:ai_chat_app/ui/widgets/ai_loading_message_bubble.dart';
import 'package:ai_chat_app/ui/widgets/ai_message_bubble.dart';
import 'package:ai_chat_app/ui/widgets/failure_message_bubble.dart';
import 'package:ai_chat_app/ui/widgets/user_message_bubble.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/common.dart' hide Response;
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';

class ClientApiMock extends Mock implements ClientApi {}

ChatMessageModel getChatMessageModel() =>
    ChatMessageModel.model('Hello, how can I assist you today?');

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  late ClientApiMock mock;
  setUp(() async {
    mock = ClientApiMock();
    await getIt.reset();
    setupServiceLocator();
    await getIt.unregister<ClientApi>();
    getIt.registerSingleton<ClientApi>(mock);
  });
  tearDown(() async {
    await getIt.reset(); // cleanup بعد كل test
  });
  final successResponse = Response<Map<String, dynamic>>(
    data: {
      'candidates': [
        {
          'content': {
            'parts': [
              {'text': 'Hello from Gemini'},
            ],
            'role': 'model',
          },
          'finishReason': 'STOP',
          'index': 0,
        },
      ],
      'usageMetadata': {
        'promptTokenCount': 5,
        'candidatesTokenCount': 843,
        'totalTokenCount': 1372,
        'promptTokensDetails': [
          {'modality': 'TEXT', 'tokenCount': 5},
        ],
        'thoughtsTokenCount': 524,
        'serviceTier': 'standard',
      },
      'modelVersion': 'gemini-3-flash-preview',
      'responseId': 'SH1barH0CqyzvdIP94ePuQE',
    },
    requestOptions: RequestOptions(path: '/'),
  );

  group('Chat Screen Widgets Test Cases', () {
    testWidgets(
      'Case 1 :When the user sends a message, expect a loading bubble to appear.',
      (tester) async {
        when(
          () => mock.post<Map<String, dynamic>>(
            any(),
            data: any(named: "data"),
            queryParameters: any(named: "queryParameters"),
            headers: any(named: "headers"),
          ),
        ).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 300));
          return successResponse;
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
        when(
          () => mock.post<Map<String, dynamic>>(
            any(),
            data: any(named: "data"),
            queryParameters: any(named: "queryParameters"),
            headers: any(named: "headers"),
          ),
        ).thenAnswer((_) async => successResponse);
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
    testWidgets('case 3 : Failure Bubble .', (tester) async {
      when(
        () => mock.post<Map<String, dynamic>>(
          any(),
          data: any(named: "data"),
          queryParameters: any(named: "queryParameters"),
          headers: any(named: "headers"),
        ),
      ).thenAnswer((_) async => throw Exception('Failed to send message'));
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
        when(
          () => mock.post<Map<String, dynamic>>(
            any(),
            data: any(named: "data"),
            queryParameters: any(named: "queryParameters"),
            headers: any(named: "headers"),
          ),
        ).thenAnswer((_) async {
          counter++;
          await Future.delayed(const Duration(seconds: 2));
          if (counter == 1) {
            throw Exception('Failed to send message');
          }
          return successResponse;
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
        when(
          () => mock.post<Map<String, dynamic>>(
            any(),
            data: any(named: "data"),
            queryParameters: any(named: "queryParameters"),
            headers: any(named: "headers"),
          ),
        ).thenAnswer((_) async => throw Exception('Failed to send message'));
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
        expect(find.byType(FailureMessageBubble), findsOneWidget);
      },
    );
    testWidgets(
      'case 6 : When a failure bubble is shown and the user sends another message, expect the new message to be accepted and replaced current failure message.',
      (tester) async {
        when(
          () => mock.post<Map<String, dynamic>>(
            any(),
            data: any(named: "data"),
            queryParameters: any(named: "queryParameters"),
            headers: any(named: "headers"),
          ),
        ).thenAnswer((_) async => throw Exception('Failed to send message'));
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
        await tester.enterText(textField, 'Hello World');
        await tester.pumpAndSettle();
        await tester.tap(iconButton);
        await tester.pumpAndSettle();

        expect(find.byType(UserMessageBubble), findsNothing);
        expect(
          find.descendant(
            of: find.byType(FailureMessageBubble),
            matching: find.text('Hello World'),
          ),
          findsOneWidget,
        );
      },
    );
  });
}
