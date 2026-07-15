import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class GroupCard extends StatelessWidget {
  const GroupCard({
    super.key,
    required this.name,
    required this.amount,
    required this.frequency,
    required this.nextPayout,
    required this.position,
    this.onTap,
  });

  final String name;
  final String amount;
  final String frequency;
  final String nextPayout;
  final String position;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radius16),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacing12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.accent,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      position,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacing12),
              Text(
                amount,
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(color: AppTheme.primary),
              ),
              const SizedBox(height: AppTheme.spacing8),
              Text(
                '$frequency • Next payout $nextPayout',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
