import 'package:flutter/material.dart';

import '../theme/chat_text_styles.dart';

class MessageTimestamp extends StatelessWidget {
  const MessageTimestamp({
    super.key,
    required this.time,
    this.align = Alignment.centerRight,
    this.padding = const EdgeInsets.only(top: 4, right: 8),
  });

  final String time;
  final Alignment align;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: align,
      child: Padding(
        padding: padding,
        child: Text(time, style: ChatTextStyles.timestamp),
      ),
    );
  }
}
