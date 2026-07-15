import 'package:ai_chat_app/cubit/gemini_send_message/gemini_send_message_cubit.dart';
import 'package:ai_chat_app/repositories/gemini_send_message_repository_impl.dart';
import 'package:ai_chat_app/services/client_api.dart';
import 'package:ai_chat_app/services/gemini_chat_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'ui/screens/chat_screen.dart';

void main()async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Chat',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (_) => GeminiSendMessageCubit(
          repository: GeminiSendMessageRepositoryImpl(
            service: GeminiChatService(
              api: ClientApi(
                baseUrl: 'https://generativelanguage.googleapis.com',
              ),
            ),
          ),
        ),
        child: const ChatScreen(),
      ),
    );
  }
}
