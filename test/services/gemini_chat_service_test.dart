import 'package:ai_chat_app/models/chat_message_model.dart';
import 'package:ai_chat_app/services/client_api.dart';
import 'package:ai_chat_app/services/gemini_chat_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class ApiClientMock extends Mock implements ClientApi {}

void main() {
  late ApiClientMock mock;
  late GeminiChatService service;

  setUp(() {
    mock = ApiClientMock();
    service = GeminiChatService(api: mock);
  });

  final successResponse = Response<Map<String, dynamic>>(
    data: {
      'content': {
        'role': 'model',
        'parts': [
          {'text': 'Hello from Gemini'},
        ],
      },
      'finishReason': 'stop',
      'index': 0,
    },
    requestOptions: RequestOptions(path: '/'),
  );

  group("Test Retry Logic", () {
    test("Test Api Request success from first attempt", () async {
      // Arrange
      when(
        () => mock.post(
          any(),
          data: any(named: "data"),
          headers: any(named: "headers"),
        ),
      ).thenAnswer((_) async => successResponse);

      // Act
      final res = await service.sendMessage([]);
      // Assert
      verify(
        () => mock.post(
          any(),
          data: any(named: "data"),
          headers: any(named: "headers"),
        ),
      ).called(1); // Ensure only one call was made and successful

      /* Or
       var callCount = verify(() => mock.post(any(), data: any(named: "data"), headers: any(named: "headers"))).callCount;
       expect(callCount, equals(1));
       */
      expect(res, isA<ChatMessageModel>());
    });

  });
}
