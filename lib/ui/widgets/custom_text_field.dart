import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/chat_colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.controller,
    this.hintText = 'Type your message...',
    this.onSubmitted,
    this.onChanged,
    this.suffixIcon,
    this.maxLines = 4,
    this.minLines = 1,
    this.enabled = true,
  });

  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final Widget? suffixIcon;
  final int maxLines;
  final int minLines;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ChatColors.inputBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ChatColors.border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextField(
        controller: controller,
        enabled: enabled,
        minLines: minLines,
        maxLines: maxLines,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 15,
          height: 22 / 15,
          fontWeight: FontWeight.w400,
          color: ChatColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            height: 22 / 15,
            fontWeight: FontWeight.w400,
            color: ChatColors.textSecondary.withValues(alpha: 0.6),
          ),
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
