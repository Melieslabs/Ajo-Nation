import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../data/mock_data_repository.dart';
import '../models/group.dart';
import '../theme/app_theme.dart';

/// Auto-generated daily summary — the "instead of manually posting updates
/// into WhatsApp" feature. Entirely computed from Group's existing getters
/// (paidCount, collectedThisCycle, expectedThisCycle, collectionProgress)
/// plus member name lookups. No new state, no new model.
class DailySummaryCard extends StatelessWidget {
  const DailySummaryCard({super.key, required this.group, this.dayLabel});

  final Group group;

  /// e.g. "Day 12 Summary" — defaults to using currentCycleNumber if omitted.
  final String? dayLabel;

  @override
  Widget build(BuildContext context) {
    final repo = MockDataRepository.instance;

    final paidNames = group.memberships
        .where((m) => m.currentCycleStatus == ContributionStatus.paid)
        .map((m) => repo.member(m.memberId)?.name ?? 'Unknown')
        .toList();

    final pendingNames = group.memberships
        .where((m) => m.currentCycleStatus != ContributionStatus.paid)
        .map((m) => repo.member(m.memberId)?.name ?? 'Unknown')
        .toList();

    final progressPercent = (group.collectionProgress * 100).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.spacing20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radius20),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dayLabel ?? 'Day ${group.currentCycleNumber} Summary',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: AppTheme.spacing16),

          _summarySection(
            icon: FontAwesomeIcons.circleCheck,
            iconColor: AppTheme.primary,
            label: 'Paid (${paidNames.length})',
            names: paidNames,
          ),
          if (pendingNames.isNotEmpty) ...[
            const SizedBox(height: AppTheme.spacing16),
            _summarySection(
              icon: FontAwesomeIcons.clock,
              iconColor: AppTheme.warning,
              label: 'Pending (${pendingNames.length})',
              names: pendingNames,
            ),
          ],

          const SizedBox(height: AppTheme.spacing20),
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing16),
            decoration: BoxDecoration(
              color: AppTheme.pasteGreen,
              borderRadius: BorderRadius.circular(AppTheme.radius16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Collection',
                        style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                    const SizedBox(height: 4),
                    Text(
                      '₦${group.collectedThisCycle} / ₦${group.expectedThisCycle}',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
                Text(
                  '$progressPercent%',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 24,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summarySection({
    required FaIconData icon,
    required Color iconColor,
    required String label,
    required List<String> names,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            FaIcon(icon, size: 14, color: iconColor),
            const SizedBox(width: AppTheme.spacing8),
            Text(
              label,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: iconColor),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacing8),
        Wrap(
          spacing: AppTheme.spacing8,
          runSpacing: AppTheme.spacing8,
          children: names
              .map((name) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.background,
                      borderRadius: BorderRadius.circular(AppTheme.radius12),
                    ),
                    child: Text(
                      name,
                      style: TextStyle(fontSize: 12, color: AppTheme.textPrimary),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}