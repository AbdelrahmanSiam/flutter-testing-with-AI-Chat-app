import 'package:flutter/material.dart';

import '../theme/chat_text_styles.dart';
import 'ai_avatar.dart';

class ChatBotAppBarTitle extends StatelessWidget {
  const ChatBotAppBarTitle({
    super.key,
    required this.title,
    this.subtitle,
    this.showAvatar = true,
    this.avatarUrl,
  });

  final String title;
  final String? subtitle;
  final bool showAvatar;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showAvatar) ...[
          AiAvatar(size: 28, imageUrl: avatarUrl),
          const SizedBox(width: 10),
        ],
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: ChatTextStyles.appBarTitle,
                overflow: TextOverflow.ellipsis,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: ChatTextStyles.appBarSubtitle,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
