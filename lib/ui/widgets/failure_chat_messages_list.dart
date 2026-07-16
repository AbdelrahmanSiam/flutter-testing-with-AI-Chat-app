import 'package:ai_chat_app/models/chat_message_model.dart';
import 'package:ai_chat_app/ui/widgets/failure_message_bubble.dart';
import 'package:ai_chat_app/ui/widgets/user_message_bubble.dart';
import 'package:flutter/material.dart';

class FailureChatMessagesList extends StatelessWidget {
  const FailureChatMessagesList({
    super.key,
    required this.messages,
    required this.errorMessage,
    this.onRetry,
  });

  final List<ChatMessageModel> messages;
  final String errorMessage;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: true,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      itemCount: messages.length ,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: FailureMessageBubble(
                message: messages[messages.length - 1].content.parts.first.text,
                onRetry: onRetry,
              ),
            ),
          );
        }

        var newIndex = messages.length - (index + 1);
        final message = messages[newIndex];
        final isUser = message.isUser;
        final parts = message.content.parts;
        final intro = parts.isNotEmpty ? parts.first.text : '';

        return Align(
          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: isUser
                ? UserMessageBubble(message: intro)
                : const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}
