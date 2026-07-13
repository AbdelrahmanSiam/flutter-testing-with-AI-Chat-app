import 'package:flutter/material.dart';

import '../theme/chat_colors.dart';
import '../theme/chat_text_styles.dart';
import 'message_timestamp.dart';

class UserMessageBubble extends StatelessWidget {
  const UserMessageBubble({
    super.key,
    required this.message,
    required this.timestamp,
  });

  final String message;
  final String timestamp;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 297.5),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: ChatColors.primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.zero,
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1A000000),
                  offset: Offset(0, 4),
                  blurRadius: 6,
                  spreadRadius: -1,
                ),
                BoxShadow(
                  color: Color(0x1A000000),
                  offset: Offset(0, 2),
                  blurRadius: 4,
                  spreadRadius: -2,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 18.56, 12),
              child: Text(message, style: ChatTextStyles.userMessage),
            ),
          ),
        ),
        MessageTimestamp(time: timestamp),
      ],
    );
  }
}
