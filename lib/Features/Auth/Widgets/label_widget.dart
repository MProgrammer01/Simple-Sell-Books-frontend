import 'package:flutter/material.dart';
import 'package:sell_your_books/Core/Values/typography.dart';

class LabelWidget extends StatelessWidget {
  const LabelWidget({super.key, required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final typography = Theme.of(context).extension<TypographyApp>()!;

    return Text(
      text,
      style: typography.labelSM.copyWith(letterSpacing: 0.12, color: color),
    );
  }
}
