import 'package:ai_chat_app/cubit/gemini_send_message/gemini_send_message_cubit.dart';
import 'package:ai_chat_app/data/repositories/gemini_send_message_repository.dart';
import 'package:ai_chat_app/data/repositories/gemini_send_message_repository_impl.dart';
import 'package:ai_chat_app/services/client_api.dart';
import 'package:ai_chat_app/services/gemini_chat_service.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;
void setupServiceLocator() {
  getIt.registerSingleton<ClientApi>(
    ClientApi(baseUrl: 'https://generativelanguage.googleapis.com', dio: Dio()),
  );
  getIt.registerLazySingleton<GeminiChatService>(
   ()=> GeminiChatService(api: getIt<ClientApi>()),
  );
  getIt.registerLazySingleton<GeminiSendMessageRepository>(
   ()=> GeminiSendMessageRepositoryImpl(service: getIt<GeminiChatService>()),
  );
  getIt.registerFactory<GeminiSendMessageCubit>(
    () => GeminiSendMessageCubit(repository: getIt<GeminiSendMessageRepository>()),
  ); // Registering the cubit as a factory allows for multiple instances to be created when needed.
}
