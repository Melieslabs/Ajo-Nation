import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'primary_button.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.ctaLabel,
    this.onPressed,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? ctaLabel;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 54, color: AppTheme.primary),
            const SizedBox(height: AppTheme.spacing16),
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: AppTheme.spacing8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (ctaLabel != null && onPressed != null) ...[
              const SizedBox(height: AppTheme.spacing16),
              PrimaryButton(label: ctaLabel!, onPressed: onPressed!),
            ],
          ],
        ),
      ),
    );
  }
}
