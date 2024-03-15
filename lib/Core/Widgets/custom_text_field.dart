import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final double radius;
  final double? fontSize;
  final String? hintText;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextDirection? textDirection;
  final Function(String value)? onChanged;
  final Function()? onEditingComplete;
  const CustomTextField(
      {required this.controller,
      required this.radius,
      this.hintText,
      this.fontSize,
      this.focusNode,
      this.textDirection,
      this.keyboardType,
      this.onChanged,
      this.onEditingComplete,
      super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      controller: controller,
      keyboardType: keyboardType,
      textDirection: textDirection ?? TextDirection.ltr,
      cursorColor: const Color(0xFF140F2D),
      style: TextStyle(fontSize: fontSize),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.withOpacity(0.25),
        hintText: hintText,
        hintTextDirection: textDirection ?? TextDirection.ltr,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: Color(0xFF140F2D)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: Color(0xFF140F2D)),
        ),
      ),
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
    );
  }
}
