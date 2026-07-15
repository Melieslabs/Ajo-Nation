import 'package:flutter/foundation.dart';

import '../models/models.dart';
import '../widgets/status_badge.dart' show StatusVariant;

/// Single in-memory source of truth for the app.
///
/// This stands in for a real backend (Supabase + Paystack DVA webhooks).
/// Every screen reads from this via Provider instead of hardcoding data.
/// When the real backend lands, only this class needs to change —
/// screens keep working against the same shape.
class AppData extends ChangeNotifier {
  AppData() {
    _seed();
  }

  final List<Group> _groups = [];
  final List<Member> _members = [];
  final List<Contribution> _contributions = [];
  final List<TimelineEvent> _timelineEvents = [];

  List<Group> get groups => List.unmodifiable(_groups);

  Group? groupById(String id) {
    for (final g in _groups) {
      if (g.id == id) return g;
    }
    return null;
  }

  List<Member> membersForGroup(String groupId) =>
      _members.where((m) => m.groupId == groupId).toList()
        ..sort((a, b) => a.rotationPosition.compareTo(b.rotationPosition));

  List<TimelineEvent> timelineForGroup(String groupId) =>
      _timelineEvents.where((e) => e.groupId == groupId).toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

  /// Derives a StatusVariant for display from a member's current standing.
  /// Placeholder for what a real "missed today's payment" check would do.
  StatusVariant statusFor(Member member) {
    final group = groupById(member.groupId);
    if (group == null) return StatusVariant.pending;
    final periodsPaid = group.amountPaidToPeriods(member.amountPaidThisCycle);
    if (periodsPaid >= group.cycleLength) return StatusVariant.paid;
    if (periodsPaid == 0) return StatusVariant.late;
    return StatusVariant.pending;
  }

  /// Simulates a webhook-driven contribution (stand-in for a Paystack DVA event).
  void recordContribution({
    required String memberId,
    required String groupId,
    required double amount,
  }) {
    final memberIndex = _members.indexWhere((m) => m.id == memberId);
    if (memberIndex == -1) return;

    final member = _members[memberIndex];
    _members[memberIndex] = member.copyWith(
      amountPaidThisCycle: member.amountPaidThisCycle + amount,
    );

    _contributions.add(
      Contribution(
        id: 'c_${DateTime.now().microsecondsSinceEpoch}',
        memberId: memberId,
        groupId: groupId,
        amount: amount,
        timestamp: DateTime.now(),
        status: StatusVariant.paid,
      ),
    );

    _timelineEvents.add(
      TimelineEvent(
        id: 't_${DateTime.now().microsecondsSinceEpoch}',
        groupId: groupId,
        type: TimelineEventType.payment,
        timestamp: DateTime.now(),
        description: '${member.name} paid ₦${amount.toStringAsFixed(0)}',
      ),
    );

    notifyListeners();
  }

  void triggerPayout(String groupId, String recipientMemberId) {
    final member = _members.firstWhere((m) => m.id == recipientMemberId);
    final group = groupById(groupId);
    if (group == null) return;

    _timelineEvents.add(
      TimelineEvent(
        id: 't_${DateTime.now().microsecondsSinceEpoch}',
        groupId: groupId,
        type: TimelineEventType.payout,
        timestamp: DateTime.now(),
        description:
            'Payout of ₦${group.payoutAmount.toStringAsFixed(0)} sent to ${member.name}',
      ),
    );

    notifyListeners();
  }

  void _seed() {
    const groupId = 'g1';
    _groups.add(
      const Group(
        id: groupId,
        name: 'Ajo Circle',
        contributionAmount: 12500,
        frequency: Frequency.monthly,
        payoutAmount: 50000,
        cycleLength: 4,
        riskThresholdPercent: 50,
      ),
    );

    _members.addAll(const [
      Member(
        id: 'm1',
        groupId: groupId,
        name: 'Emelie Him',
        rotationPosition: 1,
        amountPaidThisCycle: 50000, // fully paid
      ),
      Member(
        id: 'm2',
        groupId: groupId,
        name: 'Dayo Bassey',
        rotationPosition: 2,
        amountPaidThisCycle: 0, // late
      ),
      Member(
        id: 'm3',
        groupId: groupId,
        name: 'Nneka Okafor',
        rotationPosition: 3,
        amountPaidThisCycle: 25000, // partial
      ),
    ]);

    _timelineEvents.add(
      TimelineEvent(
        id: 't_seed',
        groupId: groupId,
        type: TimelineEventType.memberJoined,
        timestamp: DateTime.now().subtract(const Duration(days: 10)),
        description: 'Group created',
      ),
    );
  }
}
