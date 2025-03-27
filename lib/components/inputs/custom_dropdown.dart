import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String labelText;
  final T value;
  final List<T> items;
  final ValueChanged<T?> onChanged;
  final String Function(T) getLabel;
  final String Function(T) getValue;

  const CustomDropdown({
    super.key,
    required this.labelText,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.getLabel,
    required this.getValue,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(getLabel(item)),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
