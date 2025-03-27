import 'package:flutter/material.dart';
import 'package:petroflow/constants/my_colors.dart';

class ReusableCard extends StatelessWidget {
  const ReusableCard(
      {super.key,
      required this.colour,
      this.cardChild,
      this.onPress,
      this.margin,
      this.padding,
      this.borderRadius});

  final Color colour;
  final Widget? cardChild;
  final VoidCallback? onPress;
  final double? margin;
  final double? padding;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        margin: EdgeInsets.all(margin ?? 0.0),
        decoration: BoxDecoration(
          color: colour ?? DynamicColors.homeCardColor(context),
          borderRadius: BorderRadius.circular(borderRadius ?? 0.0),
        ),
        child: cardChild,
      ),
    );
  }
}
