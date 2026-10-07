import 'package:flutter/material.dart';
import 'package:sell_your_books/Core/Values/colors.dart';

class LabeledFieldWidget extends StatelessWidget {
  final String _label;
  final Widget _child;

  const LabeledFieldWidget({
    super.key,
    required this._label,
    required this._child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.12,
            color: ColorsApp.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        _child,
      ],
    );
  }
}
