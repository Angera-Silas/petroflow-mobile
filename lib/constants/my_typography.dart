import 'package:flutter/material.dart';

import 'my_colors.dart';

class AppTypography {
  // Responsive text size helper
  static double _scaleFont(BuildContext context, double fontSize) {
    double screenWidth = MediaQuery.of(context).size.width;
    double scaleFactor = screenWidth / 375; // Based on a 375px-wide design
    return fontSize * scaleFactor;
  }

  // Headings
  static TextStyle heading1(BuildContext context) {
    return TextStyle(
      fontSize: _scaleFont(context, 30),
      fontWeight: FontWeight.bold,
      color: DynamicColors.textColor(context),
    );
  }

  static TextStyle heading2(BuildContext context) {
    return TextStyle(
      fontSize: _scaleFont(context, 26),
      fontWeight: FontWeight.bold,
      color: DynamicColors.textColor(context),
    );
  }

  static TextStyle heading3(BuildContext context) {
    return TextStyle(
      fontSize: _scaleFont(context, 24),
      fontWeight: FontWeight.bold,
      color: DynamicColors.textColor(context),
    );
  }

  static TextStyle heading4(BuildContext context) {
    return TextStyle(
      fontSize: _scaleFont(context, 22),
      fontWeight: FontWeight.bold,
      color: DynamicColors.textColor(context),
    );
  }

  static TextStyle heading5(BuildContext context) {
    return TextStyle(
      fontSize: _scaleFont(context, 20),
      fontWeight: FontWeight.bold,
      color: DynamicColors.textColor(context),
    );
  }

  static TextStyle heading6(BuildContext context) {
    return TextStyle(
      fontSize: _scaleFont(context, 18),
      fontWeight: FontWeight.bold,
      color: DynamicColors.textColor(context),
    );
  }

  // Buttons
  static const TextStyle largeButton = TextStyle(
    fontSize: 25.0,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  // Messages
  static TextStyle success(BuildContext context) {
    return TextStyle(
      fontSize: _scaleFont(context, 16),
      color: const Color(0xFF16A34A),
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle warning(BuildContext context) {
    return TextStyle(
      fontSize: _scaleFont(context, 16),
      color: const Color(0xFFF59E0B),
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle error(BuildContext context) {
    return TextStyle(
      fontSize: _scaleFont(context, 16),
      color: const Color(0xFFDC2626),
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle info(BuildContext context) {
    return TextStyle(
      fontSize: _scaleFont(context, 16),
      color: const Color(0xFF3B82F6),
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle muted(BuildContext context) {
    return TextStyle(
      fontSize: _scaleFont(context, 16),
      color: const Color(0xFF9CA3AF),
      fontWeight: FontWeight.bold,
    );
  }

  // Paragraphs - Body Text
  static TextStyle paragraph_medium(BuildContext context) {
    return TextStyle(
      fontSize: _scaleFont(context, 14),
      color: DynamicColors.textColor(context),
    );
  }

  static TextStyle paragraph_small(BuildContext context) {
    return TextStyle(
      fontSize: _scaleFont(context, 12),
      color: DynamicColors.textColor(context),
    );
  }

  static TextStyle paragraph_large(BuildContext context) {
    return TextStyle(
      fontSize: _scaleFont(context, 16),
      color: DynamicColors.textColor(context),
    );
  }

  // Labels (using dynamic colors)
  static TextStyle label(BuildContext context) {
    return TextStyle(
      fontSize: _scaleFont(context, 18),
      color: DynamicColors.labelColor(context),
    );
  }
}
