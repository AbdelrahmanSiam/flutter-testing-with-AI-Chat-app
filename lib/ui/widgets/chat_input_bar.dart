import 'package:flutter/material.dart';

import '../theme/chat_colors.dart';
import 'custom_text_field.dart';

class ChatInputBar extends StatelessWidget {
  const ChatInputBar({
    super.key,
    this.controller,
    this.hintText = 'Ask anything...',
    this.onSend,
  });

  final TextEditingController? controller;
  final String hintText;
  final VoidCallback? onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: const BoxDecoration(
        color: ChatColors.background,
        border: Border(top: BorderSide(color: ChatColors.border)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: CustomTextField(controller: controller, hintText: hintText),
          ),
          const SizedBox(width: 12),
          DecoratedBox(
            decoration: BoxDecoration(
              color: ChatColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: onSend,
              icon: const Icon(
                Icons.arrow_upward_rounded,
                color: ChatColors.userBubbleText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
