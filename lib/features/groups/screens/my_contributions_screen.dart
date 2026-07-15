import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

class MyContributionsScreen extends StatelessWidget {
  const MyContributionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My contributions')),
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing24),
        child: ListView(
          children: [
            Text(
              'Contribution history',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppTheme.spacing16),
            _historyTile('Community Ajo', '₦20,000', 'Paid • 12 Jul'),
            _historyTile('Family Ajo', '₦10,000', 'Pending • 2 Aug'),
            _historyTile('Friend Circle', '₦15,000', 'Paid • 6 Jul'),
          ],
        ),
      ),
    );
  }

  Widget _historyTile(String title, String amount, String meta) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(meta),
        trailing: Text(amount),
      ),
    );
  }
}
