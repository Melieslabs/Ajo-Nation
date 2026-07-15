import 'package:flutter/material.dart';

import '../../../data/mock_data_repository.dart';
import '../../../models/group.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/member_list_tile.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/status_badge.dart';

class AdminGroupDetailScreen extends StatefulWidget {
  const AdminGroupDetailScreen({super.key, required this.groupId});

  final String groupId;

  @override
  State<AdminGroupDetailScreen> createState() =>
      _AdminGroupDetailScreenState();
}

class _AdminGroupDetailScreenState extends State<AdminGroupDetailScreen> {
  final _repo = MockDataRepository.instance;

  @override
  void initState() {
    super.initState();
    _repo.addListener(_onRepoChanged);
  }

  @override
  void dispose() {
    _repo.removeListener(_onRepoChanged);
    super.dispose();
  }

  void _onRepoChanged() => setState(() {});

  StatusVariant _toStatusVariant(ContributionStatus status) =>
      switch (status) {
        ContributionStatus.paid => StatusVariant.paid,
        ContributionStatus.pending => StatusVariant.pending,
        ContributionStatus.late => StatusVariant.late,
      };

  @override
  Widget build(BuildContext context) {
    final group = _repo.group(widget.groupId);

    if (group == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Group not found')),
        body: const Center(child: Text('This group no longer exists.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(group.name)),
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
                    '${group.frequency.label[0].toUpperCase()}${group.frequency.label.substring(1)} contribution • ₦${group.contributionAmount}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppTheme.spacing8),
                  Text(
                    'Cycle ${group.currentCycleNumber} • ${group.paidCount} of ${group.totalMembers} paid',
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
            for (final membership in group.memberships)
              MemberListTile(
                name: _repo.member(membership.memberId)?.name ?? 'Unknown',
                initials: _repo.member(membership.memberId)?.initials ?? '?',
                status: _toStatusVariant(membership.currentCycleStatus),
                trailing: membership.currentCycleStatus ==
                        ContributionStatus.late
                    ? const StatusBadge(
                        label: 'Late', variant: StatusVariant.late)
                    : null,
              ),
            const SizedBox(height: AppTheme.spacing24),
            PrimaryButton(
              label: 'Trigger payout',
              onPressed: () => Navigator.of(context)
                  .pushNamed('/payout-confirmation', arguments: group.id),
            ),
          ],
        ),
      ),
    );
  }
}
