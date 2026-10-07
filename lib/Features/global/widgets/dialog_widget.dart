import 'package:flutter/material.dart';

class DialogWidget extends StatelessWidget {
  final String _dialogTitle, _dialogContent, _actionTitle;
  final void Function()? _dialogOnPressed;
  final Color? _foregroundColor;
  const DialogWidget({
    super.key,
    required this._dialogTitle,
    required this._dialogContent,
    required this._actionTitle,
    this._dialogOnPressed,
    this._foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_dialogTitle),
      content: Text(_dialogContent),
      actions: [
        TextButton(
          onPressed: () => Navigator.maybePop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _dialogOnPressed,
          style: TextButton.styleFrom(foregroundColor: _foregroundColor),
          child: Text(_actionTitle),
        ),
      ],
    );
  }
}
