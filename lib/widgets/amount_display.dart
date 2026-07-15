import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AmountDisplay extends StatelessWidget {
  const AmountDisplay({super.key, required this.amount, this.label});

  final String amount;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Text(label!, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: AppTheme.spacing8),
        Text(
          amount,
          style: Theme.of(
            context,
          ).textTheme.displaySmall?.copyWith(color: AppTheme.primary),
        ),
      ],
    );
  }
}
