import 'package:flutter/material.dart';

import '../theme/chat_colors.dart';
import '../theme/chat_text_styles.dart';

class MessageActionButton extends StatelessWidget {
  const MessageActionButton({
    super.key,
    required this.label,
    required this.icon,
    this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: ChatColors.primary),
          const SizedBox(width: 4),
          Text(label, style: ChatTextStyles.actionButton),
        ],
      ),
    );
  }
}
