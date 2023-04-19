import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final IconData? prefixIconData;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;

  const CustomTextField({super.key,
    this.labelText,
    this.hintText,
    this.prefixIconData,
    this.keyboardType,
    this.obscureText = false,
    this.controller,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIconData != null ? Icon(prefixIconData) : null,
        border: const OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
      controller: controller,
      onChanged: onChanged,
      validator: validator,
    );
  }
}
