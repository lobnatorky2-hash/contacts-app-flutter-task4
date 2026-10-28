import 'package:flutter/material.dart';

/// Rounded-square floating action button used for "add" and "delete last".
class SquareFab extends StatelessWidget {
  const SquareFab({
    super.key,
    required this.icon,
    required this.background,
    required this.foreground,
    required this.onPressed,
    this.tooltip,
  });

  final IconData icon;
  final Color background;
  final Color foreground;
  final VoidCallback onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? '',
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(16),
        elevation: 3,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onPressed,
          child: SizedBox(
            width: 64,
            height: 64,
            child: Icon(icon, size: 30, color: foreground),
          ),
        ),
      ),
    );
  }
}
