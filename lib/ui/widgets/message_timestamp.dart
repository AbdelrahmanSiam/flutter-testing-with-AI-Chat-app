import 'package:flutter/material.dart';

import '../theme/chat_text_styles.dart';
import '../utils/message_time_formatter.dart';

class MessageTimestamp extends StatelessWidget {
  const MessageTimestamp({
    super.key,
    required this.time,
    this.align = Alignment.centerRight,
    this.padding = const EdgeInsets.only(top: 4, right: 8),
  });

  final DateTime time;
  final Alignment align;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: align,
      child: Padding(
        padding: padding,
        child: Text(
          MessageTimeFormatter.format(time),
          style: ChatTextStyles.timestamp,
        ),
      ),
    );
  }
}
