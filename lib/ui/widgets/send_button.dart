import 'package:ai_chat_app/ui/theme/chat_colors.dart';
import 'package:flutter/material.dart';

class SendButton extends StatelessWidget {
  final void Function() onPressed;
  const SendButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: ChatColors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: const Icon(
          Icons.arrow_upward_rounded,
          color: ChatColors.userBubbleText,
        ),
      ),
    );
  }
}
