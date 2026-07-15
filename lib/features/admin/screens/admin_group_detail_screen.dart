import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/member_list_tile.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/status_badge.dart';

class AdminGroupDetailScreen extends StatelessWidget {
  const AdminGroupDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajo Circle')),
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing24),
        child: ListView(
          children: [
            Text(
              'Group details',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppTheme.spacing16),
            Container(
              padding: const EdgeInsets.all(AppTheme.spacing16),
              decoration: BoxDecoration(
                color: AppTheme.accent,
                borderRadius: BorderRadius.circular(AppTheme.radius16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Monthly contribution • ₦50,000',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppTheme.spacing8),
                  Text(
                    'Cycle complete • 4 of 4 paid',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacing24),
            Text(
              'Member payments',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppTheme.spacing12),
            const MemberListTile(
              name: 'Emelie Him',
              initials: 'AM',
              status: StatusVariant.paid,
            ),
            const MemberListTile(
              name: 'Dayo Bassey',
              initials: 'DB',
              status: StatusVariant.late,
              trailing: StatusBadge(label: 'Late', variant: StatusVariant.late),
            ),
            const MemberListTile(
              name: 'Nneka Okafor',
              initials: 'NO',
              status: StatusVariant.paid,
            ),
            const SizedBox(height: AppTheme.spacing24),
            PrimaryButton(
              label: 'Trigger payout',
              onPressed: () =>
                  Navigator.of(context).pushNamed('/payout-confirmation'),
            ),
          ],
        ),
      ),
    );
  }
}
