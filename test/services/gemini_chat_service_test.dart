import 'package:ai_chat_app/models/chat_message_model.dart';
import 'package:ai_chat_app/services/client_api.dart';
import 'package:ai_chat_app/services/gemini_chat_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
  DioException retryableDioException() => DioException(
    requestOptions: RequestOptions(path: '/'),
    type: DioExceptionType.connectionTimeout,
  );
  DioException notRetryableDioException() => DioException(
    requestOptions: RequestOptions(path: '/'),
    response: Response(
      requestOptions: RequestOptions(path: '/'),
      statusCode: 400,
      data: {'error': 'Bad Request'},
    ),
  );
  group("Test Retry Logic", () {
    setUpAll(() async {
      await dotenv.load(fileName: '.env');
    });
    test("Test Api Request success from first attempt", () async {
      // Arrange
      when(
        () => mock.post<Map<String, dynamic>>(
          any(),
          data: any(named: "data"),
          queryParameters: any(named: "queryParameters"),
          headers: any(named: "headers"),
        ),
      ).thenAnswer((_) async => successResponse);
      // Act
      final res = await service.sendMessage([]);
      // Assert
      verify(
        () => mock.post<Map<String, dynamic>>(
          any(),
          data: any(named: "data"),
          queryParameters: any(named: "queryParameters"),
          headers: any(named: "headers"),
        ),
      ).called(1); // Ensure only one call was made and successful
      /* Or
       var callCount = verify(() => mock.post(any(), data: any(named: "data"), headers: any(named: "headers"))).callCount;
       expect(callCount, equals(1));
       */
      expect(res, isA<ChatMessageModel>());
    });

    test("Test Api Request fails at first attempt then succeeds", () async {
      int counter = 0;
      // Arrange
      when(
        () => mock.post<Map<String, dynamic>>(
          any(),
          data: any(named: "data"),
          queryParameters: any(named: "queryParameters"),
          headers: any(named: "headers"),
        ),
      ).thenAnswer((_) async {
        counter++;
        if (counter == 1) {
          throw retryableDioException();
        }
        return successResponse;
      });
      // Act
      final res = await service.sendMessage([]);
      // Assert
      verify(
        () => mock.post<Map<String, dynamic>>(
          any(),
          data: any(named: "data"),
          queryParameters: any(named: "queryParameters"),
          headers: any(named: "headers"),
        ),
      ).called(
        2,
      ); // Ensure there two attempts to get the request and the second one was successful
      expect(res, isA<ChatMessageModel>());
    });
    test(
      "Test Api Request fails at first and second attempt then succeeds",
      () async {
        int counter = 0;
        // Arrange
        when(
          () => mock.post<Map<String, dynamic>>(
            any(),
            data: any(named: "data"),
            queryParameters: any(named: "queryParameters"),
            headers: any(named: "headers"),
          ),
        ).thenAnswer((_) async {
          counter++;
          if (counter == 3) {
            return successResponse;
          }
          throw retryableDioException();
        });
        // Act
        final res = await service.sendMessage([]);
        // Assert
        verify(
          () => mock.post<Map<String, dynamic>>(
            any(),
            data: any(named: "data"),
            queryParameters: any(named: "queryParameters"),
            headers: any(named: "headers"),
          ),
        ).called(
          3,
        ); // Ensure there three attempts to get the request and the third one was successful
        expect(res, isA<ChatMessageModel>());
      },
    );
    test(
      "Test Api Request fails at first attempt and throw non retryable exception",
      () async {
        when(
          () => mock.post<Map<String, dynamic>>(
            any(),
            data: any(named: "data"),
            queryParameters: any(named: "queryParameters"),
            headers: any(named: "headers"),
          ),
        ).thenAnswer((_) async => throw notRetryableDioException());
        await expectLater(
          () => service.sendMessage([]),
          throwsA(isA<DioException>()),
        );
      },
    );
    test(
      "Test Api Request fails at 3 attempt and throw non retryable exception",
      () async {
        when(
          () => mock.post<Map<String, dynamic>>(
            any(),
            data: any(named: "data"),
            queryParameters: any(named: "queryParameters"),
            headers: any(named: "headers"),
          ),
        ).thenAnswer((_) async => throw notRetryableDioException());
        await expectLater(
          () => service.sendMessage([]),
          throwsA(isA<DioException>()),
        );
        verify(
          () => mock.post<Map<String, dynamic>>(
            any(),
            data: any(named: "data"),
            queryParameters: any(named: "queryParameters"),
            headers: any(named: "headers"),
          ),
        ).called(
          3,
        ); // Ensure there three attempts to get the request and all of them failed
      },
    );
  });
}