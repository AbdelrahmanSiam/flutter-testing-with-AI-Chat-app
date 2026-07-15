import 'package:ai_chat_app/models/chat_message_model.dart';
import 'package:ai_chat_app/ui/widgets/ai_loading_message_bubble.dart';
import 'package:ai_chat_app/ui/widgets/ai_message_bubble.dart';
import 'package:ai_chat_app/ui/widgets/user_message_bubble.dart';
import 'package:flutter/material.dart';

class LoadingChatMessagesList extends StatelessWidget {
  const LoadingChatMessagesList({super.key, required this.messages});
  final List<ChatMessageModel> messages;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          itemCount:  messages.length + 1,
          itemBuilder: (context, index) {
            if ( index == messages.length) {
              return const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 24),
                  child: AiLoadingMessageBubble(),
                ),
              );
            }

            if (index >= messages.length) {
              return const SizedBox.shrink();
            }

            final message = messages[index];
            final isUser = message.isUser;
            final parts = message.content.parts;
            final intro = parts.isNotEmpty ? parts.first.text : '';
            final bodyParagraphs = parts.length > 1
                ? parts.skip(1).map((part) => part.text).toList()
                : <String>[];
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
}
}