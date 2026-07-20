enum GroupFrequency { daily, weekly, monthly }

extension GroupFrequencyLabel on GroupFrequency {
  String get label => switch (this) {
        GroupFrequency.daily => 'daily',
        GroupFrequency.weekly => 'weekly',
        GroupFrequency.monthly => 'monthly',
      };
}

enum ContributionStatus { paid, pending, late }

/// A member's participation in one specific group.
/// Each member has a separate [GroupMembership] (and DVA) per group they're in
/// — never one shared account per group. See project brief: DVA per member per group.
class GroupMembership {
  GroupMembership({
    required this.memberId,
    required this.dvaAccountNumber,
    required this.currentCycleStatus,
    this.contributionsPaidThisCycle = 0,
    required this.payoutPosition,
    this.hasReceivedPayout = false,
  });

  final String memberId;

  final String dvaAccountNumber;

  ContributionStatus currentCycleStatus;

  int contributionsPaidThisCycle;

  int payoutPosition;

  bool hasReceivedPayout;
}

class Group {
  Group({
    required this.id,
    required this.name,
    required this.adminId,
    required this.contributionAmount,
    required this.frequency,
    required this.payoutAmount,
    required this.riskThresholdPercent,
    required this.memberships,
    required this.inviteCode,
    this.currentCycleNumber = 1,
  });

  final String id;
  final String name;
  final String adminId;
  final num contributionAmount;
  final GroupFrequency frequency;
  final num payoutAmount;

  /// Short, human-shareable code (distinct from `id`) — what the admin
  /// actually shares with people to join. Looked up via invite_code
  /// column, not the group's UUID.
  final String inviteCode;

  /// % of the cycle a member must have paid before they're payout-eligible.
  /// One of 25 / 50 / 75 / 100 (100 = must wait until end of cycle).
  final int riskThresholdPercent;

  /// Ordered member IDs — determines who collects the pot, and when.
  List<GroupMembership> get orderedMembers {
    final members = [...memberships];
    members.sort(
      (a, b) => a.payoutPosition.compareTo(b.payoutPosition),
    );
    return members;
  }

  final List<GroupMembership> memberships;
  final int currentCycleNumber;

  int get totalMembers => memberships.length;

  int get paidCount => memberships
      .where((m) => m.currentCycleStatus == ContributionStatus.paid)
      .length;

  num get collectedThisCycle => memberships.fold<num>(
      0, (sum, m) => sum + (m.contributionsPaidThisCycle * contributionAmount));

  num get expectedThisCycle => contributionAmount * totalMembers;

  double get collectionProgress =>
      expectedThisCycle == 0 ? 0 : collectedThisCycle / expectedThisCycle;

  /// Number of payments required before a member becomes payout-eligible,
  /// derived from [riskThresholdPercent] against total cycle length (=totalMembers,
  /// since one full rotation = one payment per member).
  int get paymentsRequiredForEligibility =>
      (totalMembers * riskThresholdPercent / 100).ceil();

  bool isEligibleForPayout(String memberId) {
    final membership = memberships.where((m) => m.memberId == memberId);
    if (membership.isEmpty) return false;
    return membership.first.contributionsPaidThisCycle >=
        paymentsRequiredForEligibility;
  }

  GroupMembership? membershipFor(String memberId) {
    for (final m in memberships) {
      if (m.memberId == memberId) return m;
    }
    return null;
  }

  /// The member scheduled to receive this cycle's payout — the
  /// orderedMembers entry with the lowest payoutPosition among those who
  /// haven't received a payout yet. Null if every member has already
  /// received one this cycle (the cycle should roll over before that
  /// happens in practice) or there are no members yet.
  GroupMembership? get currentRecipient {
    final pending = orderedMembers.where((m) => !m.hasReceivedPayout);
    return pending.isEmpty ? null : pending.first;
  }
}
