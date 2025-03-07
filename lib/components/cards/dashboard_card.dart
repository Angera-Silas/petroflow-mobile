import 'package:flutter/material.dart';
import 'package:petroflow/constants/my_colors.dart' show DynamicColors;

class DashboardCard extends StatelessWidget {
  final String title;
  final IconData? icon;
  final String? value;
  final String? route;
  final double? valueFontSize;
  final double? titleFontSize;
  final double? iconSize;
  final VoidCallback? onTap;

  const DashboardCard({
    super.key,
    required this.title,
    this.icon,
    this.value,
    this.onTap,
    this.route,
    this.valueFontSize,
    this.titleFontSize,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          // Increased padding for better spacing
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center, // Centering content
            children: [
              if (icon != null) ...[
                Icon(icon, size: iconSize ?? 35, color: Colors.blue),
                const SizedBox(height: 8),
              ],
              if (value != null && value!.isNotEmpty) ...[
                Text(
                  value!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: valueFontSize ?? 16,
                    fontWeight: FontWeight.bold,
                    color: DynamicColors.textColor(context),
                  ),
                ),
                const SizedBox(height: 5),
              ],
              Flexible(
                child: Text(
                  title,
                  textAlign: TextAlign.center, // Center text alignment
                  style: TextStyle(
                    fontSize: titleFontSize ?? 14,
                    fontWeight: FontWeight.w400,
                    color: DynamicColors.textColor(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
