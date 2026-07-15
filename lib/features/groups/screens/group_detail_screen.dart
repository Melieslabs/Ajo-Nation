import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/member_list_tile.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/status_badge.dart';

class GroupDetailScreen extends StatelessWidget {
  const GroupDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Community Ajo'),
              background: Container(
                padding: const EdgeInsets.fromLTRB(
                  AppTheme.spacing24,
                  72,
                  AppTheme.spacing24,
                  0,
                ),
                color: AppTheme.accent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Weekly contribution',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppTheme.spacing8),
                    Text(
                      '₦20,000',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: AppTheme.primary,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacing24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.circle_outlined,
                          color: AppTheme.primary),
                      const SizedBox(width: AppTheme.spacing8),
                      Text(
                        'Cycle progress',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacing16),
                  Container(
                    padding: const EdgeInsets.all(AppTheme.spacing16),
                    decoration: BoxDecoration(
                      color: AppTheme.accent,
                      borderRadius: BorderRadius.circular(AppTheme.radius16),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 32,
                          backgroundColor: AppTheme.primary,
                          child: Text(
                            '75%',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: AppTheme.spacing16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '3 of 4 members paid',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: AppTheme.spacing8),
                              Text(
                                'Next payout on Thursday, 25 Jul',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing24),
                  Text(
                    'Who paid this cycle',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppTheme.spacing12),
                  const MemberListTile(
                    name: 'Amina Musa',
                    initials: 'AM',
                    status: StatusVariant.paid,
                  ),
                  const MemberListTile(
                    name: 'Dayo Bassey',
                    initials: 'DB',
                    status: StatusVariant.pending,
                  ),
                  const MemberListTile(
                    name: 'Nneka Okafor',
                    initials: 'NO',
                    status: StatusVariant.late,
                  ),
                  const SizedBox(height: AppTheme.spacing24),
                  Text(
                    'My payment status',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppTheme.spacing8),
                  const StatusBadge(
                    label: 'Pending',
                    variant: StatusVariant.pending,
                  ),
                  const SizedBox(height: AppTheme.spacing24),
                  PrimaryButton(label: 'View payment info', onPressed: () {}),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
