import 'package:flutter/material.dart';

class ReusableHomeCard extends StatelessWidget {
  const ReusableHomeCard(
      {super.key,
      required this.colour,
      this.cardChild,
      this.onPress,
      this.marginHorizontal,
      this.marginVertical,
      this.elevation,
      this.borderRadius});

  final Color colour;
  final Widget? cardChild;
  final VoidCallback? onPress;
  final double? marginHorizontal;
  final double? marginVertical;
  final double? borderRadius;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Card(
        color: colour,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 0.0),
        ),
        margin: EdgeInsets.symmetric(
            vertical: marginVertical ?? 0.0,
            horizontal: marginHorizontal ?? 0.0),
        elevation: elevation ?? 0.0,
        child: cardChild,
      ),
    );
  }
}
