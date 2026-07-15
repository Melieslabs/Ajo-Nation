import 'package:ajo_nation/widgets/my_back_button.dart';
import 'package:flutter/material.dart';

import '../../../data/mock_data_repository.dart';
import '../../../models/group.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/member_list_tile.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/status_badge.dart';

class GroupDetailScreen extends StatefulWidget {
  const GroupDetailScreen({super.key, required this.groupId});

  final String groupId;

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
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
        body: Center(child: Text('This group no longer exists.')),
      );
    }

    final myMembership = group.membershipFor(_repo.currentMemberId);
    final myStatus = myMembership?.currentCycleStatus ?? ContributionStatus.pending;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: MyBackButton(),
            expandedHeight: 220,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(group.name),
              background: Container(
                padding: const EdgeInsets.fromLTRB(
                  AppTheme.spacing24,
                  72,
                  AppTheme.spacing24,
                  0,
                ),
                color: AppTheme.accent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${group.frequency.label[0].toUpperCase()}${group.frequency.label.substring(1)} contribution',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppTheme.spacing8),
                    Text(
                      '₦${group.contributionAmount}',
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
                      Icon(Icons.circle_outlined, color: AppTheme.primary),
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
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: AppTheme.primary,
                          child: Text(
                            '${(group.collectionProgress * 100).round()}%',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: AppTheme.spacing16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${group.paidCount} of ${group.totalMembers} members paid',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: AppTheme.spacing8),
                              // TODO: real payout date once cycle scheduling logic exists.
                              Text(
                                'Cycle ${group.currentCycleNumber}',
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
                  for (final membership in group.memberships)
                    MemberListTile(
                      name: _repo.member(membership.memberId)?.name ?? 'Unknown',
                      initials: _repo.member(membership.memberId)?.initials ?? '?',
                      status: _toStatusVariant(membership.currentCycleStatus),
                    ),
                  const SizedBox(height: AppTheme.spacing24),
                  Text(
                    'My payment status',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppTheme.spacing8),
                  StatusBadge(
                    label: switch (myStatus) {
                      ContributionStatus.paid => 'Paid',
                      ContributionStatus.pending => 'Pending',
                      ContributionStatus.late => 'Late',
                    },
                    variant: _toStatusVariant(myStatus),
                  ),
                  const SizedBox(height: AppTheme.spacing24),
                  PrimaryButton(
                    label: 'View payment info',
                    onPressed: () => Navigator.of(context)
                        .pushNamed('/payment-info', arguments: group.id),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
