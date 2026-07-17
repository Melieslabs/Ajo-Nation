import 'package:ajo_nation/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  State<AdminGroupDetailScreen> createState() => _AdminGroupDetailScreenState();
}

class _AdminGroupDetailScreenState extends State<AdminGroupDetailScreen> {
  final _repo = MockDataRepository.instance;
  bool _isRefreshing = true;

  @override
  void initState() {
    super.initState();
    _repo.addListener(_onRepoChanged);
    _refresh();
  }

  Future<void> _refresh() async {
    await _repo.refreshGroup(widget.groupId);
    if (mounted) setState(() => _isRefreshing = false);
  }

  @override
  void dispose() {
    _repo.removeListener(_onRepoChanged);
    super.dispose();
  }

  void _onRepoChanged() => setState(() {});

  StatusVariant _toStatusVariant(ContributionStatus status) => switch (status) {
        ContributionStatus.paid => StatusVariant.paid,
        ContributionStatus.pending => StatusVariant.pending,
        ContributionStatus.late => StatusVariant.late,
      };

  @override
  Widget build(BuildContext context) {
    final group = _repo.group(widget.groupId);

    if (group == null) {
      if (_isRefreshing) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      return Scaffold(
        appBar: AppBar(title: const Text('Group not found')),
        body: const Center(child: Text('This group no longer exists.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(group.name),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'members':
                  Navigator.pushNamed(
                    context,
                    AppRoutes.manageMembers,
                    arguments: group.id,
                  );
                  break;

                case 'order':
                  Navigator.pushNamed(
                    context,
                    AppRoutes.managePayoutOrder,
                    arguments: group.id,
                  );
                  break;

                case 'timeline':
                  Navigator.pushNamed(
                    context,
                    AppRoutes.groupTimeline,
                    arguments: group.id,
                  );
                  break;
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'members',
                child: Text('Manage Members'),
              ),
              PopupMenuItem(
                value: 'order',
                child: Text('Manage Payout Order'),
              ),
              PopupMenuItem(
                value: 'timeline',
                child: Text('View Timeline'),
              ),
            ],
          ),
        ],
      ),
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
              'Invite code',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppTheme.spacing12),
            InkWell(
              borderRadius: BorderRadius.circular(AppTheme.radius16),
              onTap: () async {
                await Clipboard.setData(ClipboardData(text: group.inviteCode));
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Invite code copied')),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppTheme.spacing16),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(AppTheme.radius16),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      group.inviteCode,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                letterSpacing: 4,
                                fontWeight: FontWeight.w800,
                              ),
                    ),
                    Icon(Icons.copy, color: AppTheme.textSecondary, size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacing24),
            Text(
              'Member payments',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppTheme.spacing12),
            Text(
              'Tap a pending or late member to simulate their payment '
              '(stand-in for the Paystack DVA webhook, not built yet).',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppTheme.muted),
            ),
            const SizedBox(height: AppTheme.spacing12),
            for (final membership in group.memberships)
              MemberListTile(
                name: _repo.member(membership.memberId)?.name ?? 'Unknown',
                initials: _repo.member(membership.memberId)?.initials ?? '?',
                status: _toStatusVariant(membership.currentCycleStatus),
                trailing:
                    membership.currentCycleStatus == ContributionStatus.late
                        ? const StatusBadge(
                            label: 'Late', variant: StatusVariant.late)
                        : null,
                onTap: membership.currentCycleStatus == ContributionStatus.paid
                    ? null
                    : () => _repo.recordContributionPaid(
                          group.id,
                          membership.memberId,
                          group.contributionAmount,
                        ),
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
