enum TimelineEventType { paymentReceived, paymentMissed, payoutCompleted, memberJoined, memberRemoved }

/// One entry in a group's permanent activity/audit log.
class TimelineEvent {
  const TimelineEvent({
    required this.groupId,
    required this.type,
    required this.timestamp,
    required this.message,
  });

  final String groupId;
  final TimelineEventType type;
  final DateTime timestamp;

  /// Pre-formatted display text, e.g. "Ada paid ₦500" or "Week 8 payout completed".
  final String message;
}
