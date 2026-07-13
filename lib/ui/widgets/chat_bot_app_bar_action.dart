import 'package:flutter/material.dart';

import '../theme/chat_colors.dart';

class ChatBotAppBarAction extends StatelessWidget {
  const ChatBotAppBarAction({
    super.key,
    required this.icon,
    this.onTap,
    this.tooltip,
    this.iconSize = 24,
    this.color = ChatColors.textPrimary,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final String? tooltip;
  final double iconSize;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final button = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(icon, size: iconSize, color: color),
        ),
      ),
    );

    if (tooltip == null) return button;

    return Tooltip(message: tooltip!, child: button);
  }
}
