import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/primary_button.dart';

class PaymentInfoScreen extends StatelessWidget {
  const PaymentInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment info')),
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Transfer into this account',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppTheme.spacing16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacing16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bank: Access Bank',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppTheme.spacing8),
                    Text(
                      'Account number: 0012345678',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: AppTheme.spacing8),
                    Text(
                      'Amount due: ₦20,000',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: AppTheme.spacing8),
                    Text(
                      'Due date: Thursday, 25 Jul',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacing24),
            Text(
              'Instructions',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppTheme.spacing8),
            Text(
              'Use your preferred banking app to transfer the amount above before the due date. Keep the transfer receipt for your records.',
            ),
            const SizedBox(height: AppTheme.spacing24),
            PrimaryButton(label: 'Copy account details', onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
