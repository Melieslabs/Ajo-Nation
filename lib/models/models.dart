import 'package:flutter/foundation.dart';

import '../widgets/status_badge.dart' show StatusVariant;

/// How often a group collects contributions.
enum Frequency { daily, weekly, monthly }

extension FrequencyLabel on Frequency {
  String get label => switch (this) {
    Frequency.daily => 'Daily',
    Frequency.weekly => 'Weekly',
    Frequency.monthly => 'Monthly',
  };
}

/// A member's position within one specific group.
/// (A person can be a Member of many groups, each with its own record.)
@immutable
class Member {
  const Member({
    required this.id,
    required this.groupId,
    required this.name,
    required this.rotationPosition,
    this.amountPaidThisCycle = 0,
  });

  final String id;
  final String groupId;
  final String name;

  /// 1-based order in the payout rotation for this group.
  final int rotationPosition;

  /// Running total paid in the current cycle. Used against
  /// [Group.riskThresholdPercent] to determine payout eligibility.
  final double amountPaidThisCycle;

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  Member copyWith({double? amountPaidThisCycle}) => Member(
    id: id,
    groupId: groupId,
    name: name,
    rotationPosition: rotationPosition,
    amountPaidThisCycle: amountPaidThisCycle ?? this.amountPaidThisCycle,
  );
}

@immutable
class Contribution {
  const Contribution({
    required this.id,
    required this.memberId,
    required this.groupId,
    required this.amount,
    required this.timestamp,
    required this.status,
  });

  final String id;
  final String memberId;
  final String groupId;
  final double amount;
  final DateTime timestamp;
  final StatusVariant status;
}

enum TimelineEventType { payment, missed, payout, memberJoined, memberRemoved }

@immutable
class TimelineEvent {
  const TimelineEvent({
    required this.id,
    required this.groupId,
    required this.type,
    required this.timestamp,
    required this.description,
  });

  final String id;
  final String groupId;
  final TimelineEventType type;
  final DateTime timestamp;
  final String description;
}

@immutable
class Group {
  const Group({
    required this.id,
    required this.name,
    required this.contributionAmount,
    required this.frequency,
    required this.payoutAmount,
    required this.cycleLength,
    this.riskThresholdPercent = 50,
  });

  final String id;
  final String name;
  final double contributionAmount;
  final Frequency frequency;
  final double payoutAmount;

  /// Number of contribution periods in one full cycle (e.g. 40 members = 40 days).
  final int cycleLength;

  /// % of cycleLength a member must have paid before being payout-eligible.
  /// 100 = end of cycle only.
  final int riskThresholdPercent;

  int get periodsRequiredForEligibility =>
      (cycleLength * riskThresholdPercent / 100).ceil();

  bool isEligibleForPayout(Member member) {
    final periodsPaid = amountPaidToPeriods(member.amountPaidThisCycle);
    return periodsPaid >= periodsRequiredForEligibility;
  }

  int amountPaidToPeriods(double amountPaid) =>
      (amountPaid / contributionAmount).floor();
}
