import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class IconButtonFilled extends StatefulWidget {
  const IconButtonFilled({
    super.key,
    required this.onPressed,
    required this.icon,
  });

  final VoidCallback onPressed;
  final Widget icon;

  @override
  State<IconButtonFilled> createState() => _IconButtonFilledState();
}

class _IconButtonFilledState extends State<IconButtonFilled> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onPressed,
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(AppTheme.radius20),
            boxShadow: AppTheme.cardShadow,
          ),
          padding: const EdgeInsets.all(AppTheme.spacing12),
          child: widget.icon,
        ),
      ),
    );
  }
}
