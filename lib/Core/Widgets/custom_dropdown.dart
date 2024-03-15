import 'package:PriceGuardian/Core/Utils/currency.dart';
import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final double radius;
  final Currency value;
  final Function(Currency? value) onChanged;
  const CustomDropdown(
      {required this.radius,
      required this.value,
      required this.onChanged,
      super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Currency>(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: Color(0xFF140F2D)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: Color(0xFF140F2D)),
        ),
      ),
      value: value,
      onChanged: onChanged,
      items: <List>[
        ["ریال", Currency.rial],
        ["تومان", Currency.toman]
      ].map<DropdownMenuItem<Currency>>((List value) {
        return DropdownMenuItem<Currency>(
          value: value[1],
          child: Text(
            value[0],
          ),
        );
      }).toList(),
    );
  }
}
