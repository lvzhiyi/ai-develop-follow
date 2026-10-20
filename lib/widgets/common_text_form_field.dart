import 'package:flutter/material.dart';

class CommonTextFormField extends StatelessWidget {
  const CommonTextFormField({
    super.key,
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.suffixIcon,
    this.enabled = true,
    this.onFieldSubmitted,
  });
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final Widget? suffixIcon;
  final bool enabled;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    enabled: enabled,
    obscureText: obscureText,
    autocorrect: !obscureText,
    enableSuggestions: !obscureText,
    keyboardType: keyboardType,
    validator: validator,
    onFieldSubmitted: onFieldSubmitted,
    decoration: InputDecoration(labelText: label, suffixIcon: suffixIcon),
  );
}
