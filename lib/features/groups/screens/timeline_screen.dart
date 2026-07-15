import 'package:ajo_nation/data/mock_data_repository.dart';
import 'package:ajo_nation/models/timeline_event.dart';
import 'package:ajo_nation/theme/app_theme.dart';
import 'package:ajo_nation/theme/theme_controller.dart';
import 'package:ajo_nation/utils/timeline_tile.dart';
import 'package:ajo_nation/widgets/daily_summary_card.dart';
import 'package:flutter/material.dart';

/// The per-group activity feed — replaces manually posting payment updates
/// into WhatsApp. Read-only, entirely derived from MockDataRepository's
/// timeline + group data. Not a chat: no input, no messaging, nothing to type.
class TimelineScreen extends StatelessWidget {
  const TimelineScreen({super.key, required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        MockDataRepository.instance,
        ThemeController.instance,
      ]),
      builder: (context, _) {
        final repo = MockDataRepository.instance;
        final group = repo.group(groupId);

        if (group == null) {
          return Scaffold(
            backgroundColor: AppTheme.background,
            body: const Center(child: Text('Group not found')),
          );
        }

        final events = repo.timelineFor(groupId);
        final groupedEvents = _groupByDay(events);

        return Scaffold(
          backgroundColor: AppTheme.background,
          appBar: AppBar(
            backgroundColor: AppTheme.background,
            elevation: 0,
            foregroundColor: AppTheme.textPrimary,
            title: Text(
              '${group.name} · Timeline',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(AppTheme.spacing20),
              children: [
                DailySummaryCard(group: group),
                const SizedBox(height: AppTheme.spacing24),
                if (groupedEvents.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: AppTheme.spacing32),
                    child: Center(
                      child: Text(
                        'No activity yet',
                        style: TextStyle(color: AppTheme.muted, fontSize: 14),
                      ),
                    ),
                  )
                else
                  for (final entry in groupedEvents.entries) ...[
                    Text(
                      entry.key,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacing16,
                        vertical: AppTheme.spacing8,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(AppTheme.radius16),
                        boxShadow: AppTheme.cardShadow,
                      ),
                      child: Column(
                        children: [
                          for (final event in entry.value)
                            TimelineTile(event: event),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing20),
                  ],
              ],
            ),
          ),
        );
      },
    );
  }

  /// Groups events into labeled day buckets: "Today", "Yesterday", or a
  /// formatted date, preserving most-recent-first order within each day.
  /// NOTE: "Tomorrow" (scheduled reminders) from the feature spec isn't
  /// included here — that needs a reminder-scheduling data source that
  /// doesn't exist yet (same deferred-scope as payout date scheduling).
  Map<String, List<TimelineEvent>> _groupByDay(List<TimelineEvent> events) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final grouped = <String, List<TimelineEvent>>{};

    for (final event in events) {
      final eventDay = DateTime(
        event.timestamp.year,
        event.timestamp.month,
        event.timestamp.day,
      );

      final String label;
      if (eventDay == today) {
        label = 'Today';
      } else if (eventDay == yesterday) {
        label = 'Yesterday';
      } else {
        label = '${eventDay.day}/${eventDay.month}/${eventDay.year}';
      }

      grouped.putIfAbsent(label, () => []).add(event);
    }

    return grouped;
  }
}
