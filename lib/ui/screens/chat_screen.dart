import 'package:ai_chat_app/cubit/gemini_send_message/gemini_send_message_cubit.dart';
import 'package:ai_chat_app/cubit/gemini_send_message/gemini_send_message_state.dart';
import 'package:ai_chat_app/data/repositories/gemini_send_message_repository_impl.dart';
import 'package:ai_chat_app/models/chat_message_model.dart';
import 'package:ai_chat_app/services/client_api.dart';
import 'package:ai_chat_app/services/gemini_chat_service.dart';
import 'package:ai_chat_app/ui/widgets/chat_messages_list.dart';
import 'package:ai_chat_app/ui/widgets/failure_chat_messages_list.dart';
import 'package:ai_chat_app/ui/widgets/loading_chat_messages_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../theme/chat_colors.dart';
import '../widgets/chat_bot_app_bar.dart';
import '../widgets/chat_bot_app_bar_action.dart';
import '../widgets/chat_input_bar.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final List<ChatMessageModel> messages = [];

    return BlocProvider(
      create: (context) => GeminiSendMessageCubit(
        repository: GeminiSendMessageRepositoryImpl(
          service: GeminiChatService(
            api: ClientApi(
              baseUrl: 'https://generativelanguage.googleapis.com',
            ),
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: ChatColors.background,
        appBar: const ChatBotAppBar(
          title: 'Chat Bot',
          subtitle: 'Always here to help',
          leading: ChatBotAppBarAction(
            icon: Icons.arrow_back_rounded,
            tooltip: 'Back',
          ),
          actions: [
            ChatBotAppBarAction(
              icon: Icons.volume_up_outlined,
              tooltip: 'Speaker',
            ),
            ChatBotAppBarAction(icon: Icons.upload_outlined, tooltip: 'Upload'),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child:
                  BlocConsumer<GeminiSendMessageCubit, GeminiSendMessageState>(
                    listener: (context, state) {
                      if (state is GeminiSendMessageSuccess) {
                        // Add AI response
                        messages.add(
                          ChatMessageModel.model(
                            state.message.content.parts.first.text,
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is GeminiSendMessageLoading) {
                        return LoadingChatMessagesList(messages: messages);
                      }
                      if (state is GeminiSendMessageFailure) {
                        return FailureChatMessagesList(
                          messages: messages,
                          errorMessage: state.error,
                          onRetry: () {
                            context.read<GeminiSendMessageCubit>().sendMessage(
                              messages,
                            );
                          },
                        );
                      }
                      return ChatMessagesList(now: now, messages: messages);
                    },
                  ),
            ),
            ChatInputBar(messages: messages),
          ],
        ),
      ),
    );
  }
}
