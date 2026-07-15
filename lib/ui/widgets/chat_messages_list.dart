import 'package:ai_chat_app/cubit/gemini_send_message/gemini_send_message_cubit.dart';
import 'package:ai_chat_app/cubit/gemini_send_message/gemini_send_message_state.dart';
import 'package:ai_chat_app/models/chat_message_model.dart';
import 'package:ai_chat_app/ui/widgets/ai_loading_message_bubble.dart';
import 'package:ai_chat_app/ui/widgets/ai_message_bubble.dart';
import 'package:ai_chat_app/ui/widgets/user_message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatMessagesList extends StatelessWidget {
  const ChatMessagesList({
    super.key,
    required this.now,
    required this.messages,
  });

  final DateTime now;
  final List<ChatMessageModel> messages;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GeminiSendMessageCubit, GeminiSendMessageState>(
      listener: (context, state) {
        if (state is GeminiSendMessageSuccess) {
          // Add AI response
          messages.add(
            ChatMessageModel.model(state.message.content.parts.first.text),
          );
        }
      },
      builder: (context, state) {
        bool isLoading = state is GeminiSendMessageLoading;
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          itemCount: isLoading ? messages.length + 1 : messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            final isUser = message.isUser;
            final parts = message.content.parts;
            final intro = parts.isNotEmpty ? parts.first.text : '';
            final bodyParagraphs = parts.length > 1
                ? parts.skip(1).map((part) => part.text).toList()
                : <String>[];
            if (index == messages.length && isLoading) {
              return Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: const AiLoadingMessageBubble(),
                ),
              );
            }
            return Align(
              alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: isUser
                    ? UserMessageBubble(message: intro)
                    : AiMessageBubble(
                        intro: intro,
                        bodyParagraphs: bodyParagraphs,
                      ),
              ),
            );
          },
        );
      },
    );
  }
}
