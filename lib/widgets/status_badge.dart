import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

enum StatusVariant { paid, pending, late }

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.label, required this.variant});

  final String label;
  final StatusVariant variant;

  @override
  Widget build(BuildContext context) {
    final color = switch (variant) {
      StatusVariant.paid => AppTheme.primary,
      StatusVariant.pending => AppTheme.warning,
      StatusVariant.late => AppTheme.danger,
    };

    final background = switch (variant) {
      StatusVariant.paid => AppTheme.accent,
      StatusVariant.pending => const Color(0xFFFFF7E6),
      StatusVariant.late => const Color(0xFFFEE2E2),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacing12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
