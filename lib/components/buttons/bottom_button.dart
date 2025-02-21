import 'package:flutter/material.dart';
import 'package:petroflow/constants/constants.dart';
import 'package:petroflow/constants/my_colors.dart';
import 'package:petroflow/constants/my_typography.dart';

class BottomButton extends StatelessWidget {
  const BottomButton(
      {super.key,
      required this.buttonTitle,
      required this.onTap,
      this.bradius});

  final VoidCallback onTap;
  final String buttonTitle;
  final BorderRadiusGeometry? bradius;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 24.0),
        width: double.infinity,
        height: kBottomContainerHeight,
        decoration: BoxDecoration(
          color: DynamicColors.bottomContainerColor(context),
          borderRadius: bradius,
        ),
        child: Center(
          child: Text(
            buttonTitle,
            style: AppTypography.largeButton,
          ),
        ),
      ),
    );
  }
}
