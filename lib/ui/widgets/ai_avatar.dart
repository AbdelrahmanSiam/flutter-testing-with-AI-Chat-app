import 'package:flutter/material.dart';

import '../theme/chat_colors.dart';

class AiAvatar extends StatelessWidget {
  const AiAvatar({
    super.key,
    this.size = 32,
    this.imageUrl,
  });

  final double size;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ChatColors.inputBackground,
        border: Border.all(color: ChatColors.border),
        image: imageUrl != null
            ? DecorationImage(
                image: NetworkImage(imageUrl!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: imageUrl == null
          ? Icon(
              Icons.smart_toy_outlined,
              size: size * 0.55,
              color: ChatColors.primary,
            )
          : null,
    );
  }
}
