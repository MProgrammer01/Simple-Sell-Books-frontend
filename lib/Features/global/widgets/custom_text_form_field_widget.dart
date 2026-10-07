import 'package:flutter/material.dart';
import 'package:sell_your_books/Core/Values/colors.dart';

class CustomTextFormFieldWidget extends StatelessWidget {
  final TextEditingController? _controller;
  final TextInputType? _keyboardType;
  final String? _hintText;
  final String? Function(String?)? _validator;
  final int? _maxLines;
  final Widget? _prefixIcon;
  final Widget? _suffixIcon;
  final bool obscureText;
  const CustomTextFormFieldWidget({
    super.key,
    this._controller,
    this._keyboardType,
    this._hintText,
    this._validator,
    this._maxLines = 1,
    this._prefixIcon,
    this._suffixIcon,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      keyboardType: _keyboardType,
      decoration: _fieldDecoration(_hintText ?? 'Enter text', _prefixIcon),
      validator: _validator,
      maxLines: _maxLines,
      obscureText: obscureText,
    );
  }

  InputDecoration _fieldDecoration(String hint, Widget? prefixIcon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: prefixIcon,
      suffixIcon: _suffixIcon,
      hintStyle: TextStyle(color: ColorsApp.onSurfaceVariant, fontSize: 14),
      filled: true,
      fillColor: ColorsApp.surface,
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: ColorsApp.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: ColorsApp.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: ColorsApp.primary),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: ColorsApp.error),
      ),
    );
  }
}
