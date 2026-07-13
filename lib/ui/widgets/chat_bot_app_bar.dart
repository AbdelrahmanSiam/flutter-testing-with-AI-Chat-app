import 'package:flutter/material.dart';

import '../theme/chat_colors.dart';
import 'chat_bot_app_bar_title.dart';

class ChatBotAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatBotAppBar({
    super.key,
    this.title = 'Chat Bot',
    this.subtitle,
    this.leading,
    this.actions = const [],
    this.showAvatar = true,
    this.avatarUrl,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget> actions;
  final bool showAvatar;
  final String? avatarUrl;

  @override
  Size get preferredSize => const Size.fromHeight(75.5);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ChatColors.appBarBackground,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: 12),
            ],
            Expanded(
              child: ChatBotAppBarTitle(
                title: title,
                subtitle: subtitle,
                showAvatar: showAvatar,
                avatarUrl: avatarUrl,
              ),
            ),
            if (actions.isNotEmpty)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < actions.length; i++) ...[
                    if (i > 0) const SizedBox(width: 8),
                    actions[i],
                  ],
                ],
              ),
          ],
        ),
      ),
    );
  }
}
