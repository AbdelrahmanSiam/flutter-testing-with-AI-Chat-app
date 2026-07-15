import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/chat_colors.dart';
import 'ai_avatar.dart';

class AiLoadingMessageBubble extends StatefulWidget {
  const AiLoadingMessageBubble({super.key, this.avatarUrl});

  final String? avatarUrl;

  @override
  State<AiLoadingMessageBubble> createState() => _AiLoadingMessageBubbleState();
}

class _AiLoadingMessageBubbleState extends State<AiLoadingMessageBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                child: AiAvatar(imageUrl: widget.avatarUrl),
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
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, _) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(3, (index) {
                            final progress = (_controller.value + index / 3) % 1.0;
                            final opacity =
                                0.35 + (0.65 * (0.5 + 0.5 * math.sin(progress * math.pi * 2)));
                            final translateY =
                                -2.5 + (2.5 * math.sin(progress * math.pi * 2));

                            return Padding(
                              padding: EdgeInsets.only(right: index < 2 ? 6 : 0),
                              child: Transform.translate(
                                offset: Offset(0, translateY),
                                child: Opacity(
                                  opacity: opacity,
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: ChatColors.textSecondary,
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
