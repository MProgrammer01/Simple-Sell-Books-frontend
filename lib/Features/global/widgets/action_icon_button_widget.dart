import 'package:flutter/material.dart';
import 'package:sell_your_books/Core/Values/colors.dart';

class ActionIconButtonWidget extends StatefulWidget {
  const ActionIconButtonWidget({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.hoverColor,
    required this.hoverBg,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final Color hoverColor;
  final Color hoverBg;
  final void Function()? onTap;

  @override
  State<ActionIconButtonWidget> createState() => _ActionIconButtonWidgetState();
}

class _ActionIconButtonWidgetState extends State<ActionIconButtonWidget> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovering = true),
        onExit: (_) => setState(() => _hovering = false),
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: widget.onTap,
          child: Container(
            margin: const EdgeInsets.all(2),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: _hovering ? widget.hoverBg : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              widget.icon,
              size: 20,
              color: _hovering ? widget.hoverColor : ColorsApp.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
