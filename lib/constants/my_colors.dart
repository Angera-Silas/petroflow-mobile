import 'package:flutter/material.dart';

// Dark theme colors
const kDarkPrimaryColor = Color(0xFF111827); // Dark Gray
const kDarkSecondaryColor = Color(0xFF2D3748); // Dark gray
const kDarkBackgroundColor = Color(0xFF0A0E21); // Dark background
const kDarkActiveCardColor = Color(0xFF1D1E33); // Active card color
const kDarkInactiveCardColor = Color(0xFF111328); // Inactive card color
const kDarkBottomContainerColor = Color(0xCC1C6E09); // Bottom container color
const kDarkLabelColor = Color(0xFF8D8E98); // Label text color
const kDarkTextColor = Color(0xFFFFFFFF); // White text for dark theme
const kDarkSuccessColor = Color(0xFF16A34A); // Green for success messages
const kDarkDangerColor = Color(0xFFDC2626); // Red for danger/error
const kDarkWarningColor = Color(0xFFF59E0B); // Yellow for warning messages
const kDarkInfoColor = Color(0xFF3B82F6); // Blue for info messages
const kDarkMutedColor = Color(0xFF6B7280); // Muted gray for secondary text
const kDarkDividerColor = Color(0xFF374151); // Divider color for dark theme
const kDarkTextHighlightColor = Color(0xFF2563EB); // Highlight color for text
const kDarkButtonHoverColor = Color(0xFF2D3748); // Hover color for buttons

// Light theme colors
const kLightPrimaryColor = Color(0xFFF3F4F6); // Light gray
const kLightSecondaryColor = Color(0xFFF9FAFB); // Very light gray
const kLightBackgroundColor = Color(0xFFFFFFFF); // White background
const kLightActiveCardColor = Color(0xFF5D5D5D); // Active card color
const kLightInactiveCardColor = Color(0xFF8D8E98); // Inactive card color
const kLightBottomContainerColor = Color(0xFF1C6E09); // Bottom container color
const kLightLabelColor = Color(0xFFf1f1f1); // Light label text color
const kLightTextColor = Color(0xFF000000); // Black text for light theme
const kLightSuccessColor = Color(0xFF16A34A); // Green for success messages
const kLightDangerColor = Color(0xFFDC2626); // Red for danger/error
const kLightWarningColor = Color(0xFFF59E0B); // Yellow for warning messages
const kLightInfoColor = Color(0xFF3B82F6); // Blue for info messages
const kLightMutedColor = Color(0xFF9CA3AF); // Muted gray for secondary text
const kLightDividerColor = Color(0xFFE5E7EB); // Divider color for light theme
const kLightTextHighlightColor = Color(0xFF2563EB); // Highlight color for text
const kLightButtonHoverColor = Color(0xFFEDF2F7); // Hover color for buttons

// Transparent color
const kTransparentColor = Colors.transparent;

class DynamicColors {
  // Retrieve active colors based on theme brightness
  static Color activeCardColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? kDarkActiveCardColor
        : kLightActiveCardColor;
  }

  static Color inactiveCardColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? kDarkInactiveCardColor
        : kLightInactiveCardColor;
  }

  static Color bottomContainerColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? kDarkBottomContainerColor
        : kLightBottomContainerColor;
  }

  static Color labelColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? kDarkLabelColor
        : kLightLabelColor;
  }

  static Color primaryCardColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? kDarkBackgroundColor
        : kLightBackgroundColor;
  }

  static Color activesliderCardColor(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }

  // Adding color retrieval methods for success, danger, warning, info
  static Color successColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? kDarkSuccessColor
        : kLightSuccessColor;
  }

  static Color dangerColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? kDarkDangerColor
        : kLightDangerColor;
  }

  static Color warningColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? kDarkWarningColor
        : kLightWarningColor;
  }

  static Color infoColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? kDarkInfoColor
        : kLightInfoColor;
  }

  static Color mutedColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? kDarkMutedColor
        : kLightMutedColor;
  }

  // Divider color for both themes
  static Color dividerColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? kDarkDividerColor
        : kLightDividerColor;
  }

  static Color textColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? kDarkTextColor
        : kLightTextColor;
  }

  // Text highlight color for both themes
  static Color textHighlightColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? kDarkTextHighlightColor
        : kLightTextHighlightColor;
  }

  // Hover color for buttons (for both themes)
  static Color buttonHoverColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? kDarkButtonHoverColor
        : kLightButtonHoverColor;
  }
}
