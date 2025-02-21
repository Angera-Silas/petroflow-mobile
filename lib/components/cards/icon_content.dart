import 'package:flutter/material.dart';
import 'package:petroflow/constants/my_typography.dart';

class IconContent extends StatelessWidget {
  const IconContent({super.key, this.icon, this.label});

  final String? label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 40.0,
          color: Colors.white,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          "$label",
          style: AppTypography.label(context),
        )
      ],
    );
  }
}
