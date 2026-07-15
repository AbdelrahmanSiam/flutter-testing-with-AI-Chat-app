import 'package:flutter/material.dart';

import '../theme/chat_text_styles.dart';

class FailureMessageBubble extends StatelessWidget {
  const FailureMessageBubble({
    super.key,
    required this.message,
    this.onRetry,
    this.timestamp,
  });

  final String message;
  final VoidCallback? onRetry;
  final DateTime? timestamp;

  String _formatMessage(String value) {
    final cleaned = value
        .replaceFirst(RegExp(r'^(Exception|Error):\s*', caseSensitive: false), '')
        .trim();

    if (cleaned.isEmpty) {
      return 'Something went wrong';
    }

    final lines = cleaned.split(RegExp(r'\r?\n')).where((line) => line.trim().isNotEmpty).toList();
    final firstLine = lines.isNotEmpty ? lines.first : cleaned;

    if (firstLine.length > 90) {
      return '${firstLine.substring(0, 87)}...';
    }

    return firstLine;
  }

  @override
  Widget build(BuildContext context) {
    final displayMessage = _formatMessage(message);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 310),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3F3),
              border: Border.all(color: const Color(0xFFD32F2F), width: 1.2),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.zero,
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 18.56, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        color: Color(0xFFD32F2F),
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          displayMessage,
                          style: ChatTextStyles.userMessage.copyWith(
                            color: const Color(0xFFD32F2F),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (onRetry != null) ...[
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: onRetry,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      icon: const Icon(
                        Icons.refresh,
                        size: 16,
                        color: Color(0xFFD32F2F),
                      ),
                      label: const Text(
                        'Retry',
                        style: TextStyle(
                          color: Color(0xFFD32F2F),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
