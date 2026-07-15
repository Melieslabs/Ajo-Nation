import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class FintechCard extends StatelessWidget {
  const FintechCard({
    super.key,
    required this.child,
    this.color,
  });

  final Widget child;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radius24),
        boxShadow: AppTheme.cardShadow,
      ),
      child: child,
    );
  }
}
