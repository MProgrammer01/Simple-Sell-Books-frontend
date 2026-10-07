import 'package:flutter/material.dart';
import 'package:sell_your_books/Core/Values/colors.dart';

class ObscureToggleWidget extends StatelessWidget {
  const new({super.key, required this.obscured, required this.onTap});

  final bool obscured;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(
        obscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        size: 20,
        color: ColorsApp.outline,
      ),
    );
  }
}
