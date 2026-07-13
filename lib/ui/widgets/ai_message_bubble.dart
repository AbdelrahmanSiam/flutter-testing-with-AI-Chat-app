import 'package:flutter/material.dart';

import '../theme/chat_colors.dart';
import '../theme/chat_text_styles.dart';
import 'ai_avatar.dart';
import 'message_action_button.dart';
import 'message_timestamp.dart';

class AiMessageBubble extends StatelessWidget {
  const AiMessageBubble({
    super.key,
    required this.intro,
    required this.bodyParagraphs,
    required this.timestamp,
    this.showRegenerate = true,
    this.onCopy,
    this.onRegenerate,
    this.avatarUrl,
  });

  final String intro;
  final List<String> bodyParagraphs;
  final String timestamp;
  final bool showRegenerate;
  final VoidCallback? onCopy;
  final VoidCallback? onRegenerate;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 315),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: AiAvatar(imageUrl: avatarUrl),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: ChatColors.border),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.zero,
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(intro, style: ChatTextStyles.messageBody),
                        if (bodyParagraphs.isNotEmpty) ...[
                          const SizedBox(height: 7.5),
                          for (var i = 0; i < bodyParagraphs.length; i++) ...[
                            if (i > 0) const SizedBox(height: 8),
                            Text(
                              bodyParagraphs[i],
                              style: ChatTextStyles.messageBodyLarge,
                            ),
                          ],
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4, left: 40),
          child: Row(
            children: [
              MessageActionButton(
                label: 'Copy',
                icon: Icons.copy_outlined,
                onTap: onCopy,
              ),
              if (showRegenerate) ...[
                const SizedBox(width: 8),
                MessageActionButton(
                  label: 'Regenerate',
                  icon: Icons.refresh,
                  onTap: onRegenerate,
                ),
              ],
            ],
          ),
        ),
        MessageTimestamp(
          time: timestamp,
          align: Alignment.centerLeft,
          padding: const EdgeInsets.only(top: 4, left: 40),
        ),
      ],
    );
  }
}
