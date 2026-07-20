import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/timeline_event.dart';
import '../theme/app_theme.dart';

class TimelineTile extends StatelessWidget {
  const TimelineTile({super.key, required this.event});

  final TimelineEvent event;

  @override
  Widget build(BuildContext context) {
    final visual = _visualFor(event.type);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: visual.bgColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: FaIcon(visual.icon, size: 14, color: visual.iconColor),
            ),
          ),
          const SizedBox(width: AppTheme.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.message,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatTime(event.timestamp),
                  style: TextStyle(fontSize: 12, color: AppTheme.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime t) {
    final hour = t.hour % 12 == 0 ? 12 : t.hour % 12;
    final minute = t.minute.toString().padLeft(2, '0');
    final period = t.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  _EventVisual _visualFor(TimelineEventType type) {
    switch (type) {
      case TimelineEventType.paymentReceived:
        return _EventVisual(
          icon: FontAwesomeIcons.check,
          iconColor: AppTheme.primary,
          bgColor: AppTheme.pasteGreen,
        );
      case TimelineEventType.paymentMissed:
        return _EventVisual(
          icon: FontAwesomeIcons.triangleExclamation,
          iconColor: AppTheme.danger,
          bgColor: const Color.fromRGBO(220, 38, 38, 0.1),
        );
      case TimelineEventType.payoutCompleted:
        return _EventVisual(
          icon: FontAwesomeIcons.sackDollar,
          iconColor: AppTheme.warning,
          bgColor: AppTheme.pastelOrange,
        );
      case TimelineEventType.memberJoined:
        return _EventVisual(
          icon: FontAwesomeIcons.userPlus,
          iconColor: AppTheme.info,
          bgColor: AppTheme.pastelBlue,
        );
      case TimelineEventType.memberRemoved:
        return _EventVisual(
          icon: FontAwesomeIcons.userMinus,
          iconColor: AppTheme.textSecondary,
          bgColor: AppTheme.background,
        );
      case TimelineEventType.cycleStarted:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }
}

class _EventVisual {
  const _EventVisual({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
  });

  final FaIconData icon;
  final Color iconColor;
  final Color bgColor;
}