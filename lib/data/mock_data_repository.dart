import 'package:flutter/foundation.dart';

import '../models/group.dart';
import '../models/member.dart';
import '../models/timeline_event.dart';

/// In-memory data layer, same singleton pattern as ThemeController.
/// Stands in for the real backend (Supabase + Paystack DVA webhooks) until
/// that's wired up — swap this out later without touching any screen, since
/// screens only ever talk to this class, never to hardcoded data.
class MockDataRepository extends ChangeNotifier {
  MockDataRepository._() {
    _seed();
  }

  static final MockDataRepository instance = MockDataRepository._();

  /// TEMPORARY: stands in for the logged-in user until auth is wired up.
  /// Replace with the real session's member id once sign-in is connected.
  String currentMemberId = 'm2';

  /// TEMPORARY: same pattern as currentMemberId, for the admin side.
  /// Replace once auth carries a real account_type + user id.
  String currentAdminId = 'admin1';

  /// TEMPORARY: stands in for account_type until auth actually sets it.
  /// AppRouter reads this to decide AdminHomeScreen vs MemberHomeScreen.
  /// Flip this string to 'member' during dev to test the member-side flow.
  String currentAccountType = 'admin'; // 'admin' | 'member'

  /// Call this from the Logout action, BEFORE navigating back to splash.
  /// MockDataRepository is a singleton that lives for the whole app session
  /// — logging out only clearing the navigation stack (pushNamedAndRemoveUntil)
  /// leaves currentAccountType, currentMemberId, and every created/joined
  /// group sitting in memory untouched. That's why re-running signup in the
  /// same session skips straight to whatever role was picked last time —
  /// nothing ever cleared it. A full hot restart "fixes" it only because
  /// restart wipes the whole singleton, not because logout actually worked.
  void resetForLogout() {
    currentAccountType = 'admin'; // back to a defined default, not leftover state
    currentMemberId = 'm2';
    currentAdminId = 'admin1';
    // Deliberately NOT clearing _groups/_members/_timeline here — those are
    // your seeded demo data plus anything created this session. If you want
    // a true "wipe everything, start over" logout, call _seed() again after
    // clearing the maps. Left as data-preserving for now since you're still
    // actively testing group creation/join flows and probably don't want
    // to lose them every time you test the login loop.
    notifyListeners();
  }

  final Map<String, Member> _members = {};
  final Map<String, Group> _groups = {};
  final List<TimelineEvent> _timeline = [];

  List<Group> get groups => _groups.values.toList();

  /// Groups the currently logged-in admin manages. This is what
  /// AdminHomeScreen should render — never the full group list.
  List<Group> get managedGroups =>
      _groups.values.where((g) => g.adminId == currentAdminId).toList();

  /// Groups the currently logged-in member belongs to. This is what
  /// MemberHomeScreen should render.
  List<Group> get joinedGroups => _groups.values
      .where((g) => g.membershipFor(currentMemberId) != null)
      .toList();

  Group? group(String groupId) => _groups[groupId];

  Member? member(String memberId) => _members[memberId];

  List<TimelineEvent> timelineFor(String groupId) => _timeline
      .where((e) => e.groupId == groupId)
      .toList()
      .reversed
      .toList(); // most recent first

  /// Simulates a Paystack DVA webhook: a payment landed for (memberId, groupId).
  /// This is the ONLY path that should ever mark a contribution paid —
  /// no manual "mark paid" button, per project brief.
  void recordContributionPaid(String groupId, String memberId, num amount) {
    final group = _groups[groupId];
    final membership = group?.membershipFor(memberId);
    if (group == null || membership == null) return;

    membership.currentCycleStatus = ContributionStatus.paid;
    membership.contributionsPaidThisCycle += 1;

    final memberName = _members[memberId]?.name ?? 'Unknown';
    _timeline.add(TimelineEvent(
      groupId: groupId,
      type: TimelineEventType.paymentReceived,
      timestamp: DateTime.now(),
      message: '$memberName paid ₦$amount',
    ));

    notifyListeners();
  }

  /// Creates a new group owned by currentAdminId, with no members yet
  /// (members are added via JoinGroupScreen or AddManageMembersScreen).
  /// Returns the new group's id, which the caller can navigate to directly.
  String createGroup({
    required String name,
    required num contributionAmount,
    required GroupFrequency frequency,
    required num payoutAmount,
    required int riskThresholdPercent,
  }) {
    final id = 'g${_groups.length + 1}-${DateTime.now().millisecondsSinceEpoch}';

    _groups[id] = Group(
      id: id,
      name: name,
      adminId: currentAdminId,
      contributionAmount: contributionAmount,
      frequency: frequency,
      payoutAmount: payoutAmount,
      riskThresholdPercent: riskThresholdPercent,
      payoutRotation: [],
      memberships: [],
    );

    notifyListeners();
    return id;
  }

  /// Looks up a group by invite code without joining — used for
  /// JoinGroupScreen's preview step, before the member confirms.
  /// NOTE: invite code is currently just the group's id (see class docs
  /// on Group re: no separate inviteCode field yet — pragmatic for now,
  /// swap to a real short shareable code later without changing callers).
  Group? previewGroupByInviteCode(String inviteCode) => _groups[inviteCode];

  /// Joins currentMemberId to the group matching inviteCode. Returns the
  /// joined Group, or null if the code doesn't match any group.
  /// Safe to call twice — if already a member, just returns the group as-is.
  Group? joinGroup(String inviteCode) {
    final group = _groups[inviteCode];
    if (group == null) return null;

    final alreadyMember = group.membershipFor(currentMemberId) != null;
    if (!alreadyMember) {
      group.memberships.add(GroupMembership(
        memberId: currentMemberId,
        dvaAccountNumber: _generateDvaAccountNumber(),
        currentCycleStatus: ContributionStatus.pending,
      ));
      group.payoutRotation.add(currentMemberId);

      final memberName = _members[currentMemberId]?.name ?? 'A member';
      _timeline.add(TimelineEvent(
        groupId: group.id,
        type: TimelineEventType.memberJoined,
        timestamp: DateTime.now(),
        message: '$memberName joined the group',
      ));
    }

    notifyListeners();
    return group;
  }

  /// Mock DVA number generator — real ones come from Paystack once that's
  /// wired up. Just needs to look plausible and not collide during a demo.
  String _generateDvaAccountNumber() {
    final seed = DateTime.now().millisecondsSinceEpoch % 1000000000;
    return '90${seed.toString().padLeft(8, '0')}';
  }

  void _seed() {
    final ada = Member(id: 'm1', name: 'Emelie Him');
    final dayo = Member(id: 'm2', name: 'Dayo Bassey');
    final nneka = Member(id: 'm3', name: 'Nneka Okafor');
    for (final m in [ada, dayo, nneka]) {
      _members[m.id] = m;
    }

    final group = Group(
      id: 'g1',
      name: 'Ajo Circle',
      adminId: 'admin1',
      contributionAmount: 50000,
      frequency: GroupFrequency.monthly,
      payoutAmount: 50000,
      riskThresholdPercent: 50,
      payoutRotation: ['m1', 'm2', 'm3'],
      memberships: [
        GroupMembership(
          memberId: 'm1',
          dvaAccountNumber: '9010000001',
          currentCycleStatus: ContributionStatus.paid,
          contributionsPaidThisCycle: 4,
        ),
        GroupMembership(
          memberId: 'm2',
          dvaAccountNumber: '9010000002',
          currentCycleStatus: ContributionStatus.late,
          contributionsPaidThisCycle: 2,
        ),
        GroupMembership(
          memberId: 'm3',
          dvaAccountNumber: '9010000003',
          currentCycleStatus: ContributionStatus.paid,
          contributionsPaidThisCycle: 4,
        ),
      ],
    );
    _groups[group.id] = group;

    _timeline.addAll([
      TimelineEvent(
        groupId: 'g1',
        type: TimelineEventType.memberJoined,
        timestamp: DateTime.now().subtract(const Duration(days: 10)),
        message: 'Nneka Okafor joined the group',
      ),
      TimelineEvent(
        groupId: 'g1',
        type: TimelineEventType.paymentReceived,
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        message: 'Emelie Him paid ₦50,000',
      ),
      TimelineEvent(
        groupId: 'g1',
        type: TimelineEventType.paymentMissed,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        message: 'Dayo Bassey missed today\'s payment',
      ),
    ]);
  }
}