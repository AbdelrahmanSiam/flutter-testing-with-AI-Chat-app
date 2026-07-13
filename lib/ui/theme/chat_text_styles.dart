import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'chat_colors.dart';

abstract final class ChatTextStyles {
  static TextStyle get messageBody => GoogleFonts.plusJakartaSans(
        fontSize: 15,
        height: 22 / 15,
        fontWeight: FontWeight.w400,
        color: ChatColors.textPrimary,
      );

  static TextStyle get messageBodyLarge => GoogleFonts.plusJakartaSans(
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w400,
        color: ChatColors.textPrimary,
      );

  static TextStyle get userMessage => GoogleFonts.plusJakartaSans(
        fontSize: 15,
        height: 22 / 15,
        fontWeight: FontWeight.w400,
        color: ChatColors.userBubbleText,
      );

  static TextStyle get timestamp => GoogleFonts.plusJakartaSans(
        fontSize: 12,
        height: 16 / 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.6,
        color: ChatColors.textSecondary,
      );

  static TextStyle get actionButton => GoogleFonts.plusJakartaSans(
        fontSize: 12,
        height: 16 / 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.6,
        color: ChatColors.primary,
      );
}
