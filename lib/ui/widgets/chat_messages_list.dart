import 'package:ai_chat_app/models/chat_message_model.dart';
import 'package:ai_chat_app/ui/widgets/ai_message_bubble.dart';
import 'package:ai_chat_app/ui/widgets/user_message_bubble.dart';
import 'package:flutter/material.dart';

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
    return ListView.builder(
      reverse: true,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        var newIndex = messages.length - (index + 1);
        final message = messages[newIndex];
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
                : AiMessageBubble(intro: intro, bodyParagraphs: bodyParagraphs),
          ),
        );
      },
    );
  }
}
