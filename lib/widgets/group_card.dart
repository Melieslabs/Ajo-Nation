import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'fintech_card.dart';

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
    return FintechCard(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.radius24),
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacing20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacing14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primarySoft,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        position,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacing16),
                Text(
                  amount,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: AppTheme.spacing12),
                Text(
                  '$frequency • Next payout $nextPayout',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
