import 'package:flutter/material.dart';
import 'package:petroflow/components/cards/reusable_home_card.dart'
    show ReusableHomeCard;
import 'package:petroflow/constants/my_colors.dart' show DynamicColors;

class HomeCard extends StatelessWidget {
  final String title;
  final IconData? icon;
  final String? value;
  final String? route;
  final double? valueFontSize;
  final double? titleFontSize;
  final double? iconSize;
  final VoidCallback? onTap;

  const HomeCard({
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
    final double iconSize = this.iconSize ?? 40.0;
    final double horizontalPadding = 4.0;
    final double verticalPadding = 1.0;

    return ReusableHomeCard(
      colour: DynamicColors.homeCardColor(context),
      onPress: onTap,
      marginHorizontal: 1.0,
      marginVertical: 1.0,
      borderRadius: 1.0,
      elevation: 4.0,
      cardChild: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) Icon(icon, size: iconSize, color: Colors.blue),
            const SizedBox(width: 8),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: titleFontSize ?? 16,
                      color: DynamicColors.textColor(context),
                    ),
                  ),
                  if (value != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      value!,
                      style: TextStyle(
                        fontSize: valueFontSize ?? 14,
                        fontWeight: FontWeight.bold,
                        color: DynamicColors.textColor(context),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
