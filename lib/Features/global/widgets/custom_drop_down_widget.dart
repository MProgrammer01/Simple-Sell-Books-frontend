import 'package:flutter/material.dart';
import 'package:sell_your_books/Core/Values/colors.dart';

class CustomDropDownWidget extends StatelessWidget {
  const CustomDropDownWidget({
    super.key,
    required this._hint,
    required this._value,
    required this._items,
    required this._onChanged,
  });

  final String _hint;
  final String? _value;
  final List<String> _items;
  final ValueChanged<String?> _onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: ColorsApp.surface,
        border: Border.all(color: ColorsApp.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _value,
          isExpanded: true,
          hint: Text(
            _hint,
            style: TextStyle(fontSize: 14, color: ColorsApp.onSurfaceVariant),
          ),
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: ColorsApp.onSurfaceVariant,
          ),
          style: TextStyle(fontSize: 14, color: ColorsApp.onSurface),
          items: [
            for (final item in _items)
              DropdownMenuItem(value: item, child: Text(item)),
          ],
          onChanged: _onChanged,
        ),
      ),
    );
  }
}