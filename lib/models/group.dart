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
  });

  final String memberId;

  /// Dedicated Virtual Account number for this member, in this group only.
  final String dvaAccountNumber;

  ContributionStatus currentCycleStatus;
  int contributionsPaidThisCycle;
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
    required this.payoutRotation,
    required this.memberships,
    this.currentCycleNumber = 1,
  });

  final String id;
  final String name;
  final String adminId;
  final num contributionAmount;
  final GroupFrequency frequency;
  final num payoutAmount;

  /// % of the cycle a member must have paid before they're payout-eligible.
  /// One of 25 / 50 / 75 / 100 (100 = must wait until end of cycle).
  final int riskThresholdPercent;

  /// Ordered member IDs — determines who collects the pot, and when.
  final List<String> payoutRotation;

  final List<GroupMembership> memberships;
  final int currentCycleNumber;

  int get totalMembers => memberships.length;

  int get paidCount => memberships
      .where((m) => m.currentCycleStatus == ContributionStatus.paid)
      .length;

  num get collectedThisCycle =>
      memberships.fold<num>(0, (sum, m) => sum + m.contributionsPaidThisCycle);

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
}
