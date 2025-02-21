import 'package:flutter/material.dart';
import 'package:petroflow/constants/my_colors.dart';
import 'package:petroflow/constants/my_typography.dart';

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final IconData prefixIcon;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;

  const CustomTextFormField({
    super.key,
    required this.labelText,
    required this.prefixIcon,
    required this.controller,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: DynamicColors.textColor(context),
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 1, horizontal: 5),
        counterStyle: AppTypography.paragraph_medium(context),
        labelStyle: AppTypography.paragraph_medium(context),
        labelText: labelText,
        prefixIcon: Icon(prefixIcon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: validator,
      style: AppTypography.paragraph_medium(context),
    );
  }
}
