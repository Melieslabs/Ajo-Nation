import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/primary_button.dart';

class PayoutConfirmationScreen extends StatelessWidget {
  const PayoutConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payout confirmed')),
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Receipt', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: AppTheme.spacing24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacing16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recipient: Amina Musa',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppTheme.spacing8),
                    Text(
                      'Amount: ₦50,000',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: AppTheme.spacing8),
                    Text(
                      'Date: 15 Jul 2026',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacing24),
            PrimaryButton(
              label: 'Back to dashboard',
              onPressed: () => Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/home', (route) => false),
            ),
          ],
        ),
      ),
    );
  }
}
