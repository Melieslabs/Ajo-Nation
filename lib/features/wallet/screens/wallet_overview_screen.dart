import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/amount_display.dart';

class WalletOverviewScreen extends StatelessWidget {
  const WalletOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wallet overview')),
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing24),
        child: ListView(
          children: [
            AmountDisplay(amount: '₦320,000', label: 'Total contributed'),
            const SizedBox(height: AppTheme.spacing24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacing16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Upcoming obligations',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppTheme.spacing8),
                    Text(
                      '₦50,000',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: AppTheme.spacing16),
                    Text(
                      'Next payout date',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppTheme.spacing8),
                    Text(
                      '20 Jul 2026',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
