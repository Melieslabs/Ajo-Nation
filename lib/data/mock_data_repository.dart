import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/group.dart';
import '../models/member.dart';
import '../models/timeline_event.dart';

/// Data layer. Same singleton pattern as ThemeController. Public API is
/// unchanged from the mock-data era on purpose — `groups`, `managedGroups`,
/// `joinedGroups`, `group(id)`, `member(id)`, `timelineFor(id)` all still
/// read synchronously from local in-memory maps, so no screen needed to
/// change how it *reads* data. What changed is where those maps get filled
/// from: `loadGroups()` now pulls from Supabase instead of `_seed()`.
///
/// Mutating calls (`createGroup`, `joinGroup`, `recordContributionPaid`)
/// are now real writes — they hit Supabase, then update the local cache so
/// the UI reflects the change immediately without a full reload.
class MockDataRepository extends ChangeNotifier {
  MockDataRepository._();

  static final MockDataRepository instance = MockDataRepository._();

  final SupabaseClient _supabase = Supabase.instance.client;

  /// TEMPORARY: stands in for the logged-in user until auth is wired up.
  String currentMemberId = '';

  /// TEMPORARY: same pattern as currentMemberId, for the admin side.
  String currentAdminId = '';

  /// TEMPORARY: AppRouter reads this to decide AdminHomeScreen vs
  /// MemberHomeScreen. Set for real by syncCurrentUser().
  String currentAccountType = 'admin'; // 'admin' | 'member'

  /// The signed-in user's real name, populated by syncCurrentUser().
  String currentUserName = 'User';

  bool isLoading = false;
  String? loadError;

  final Map<String, Member> _members = {};
  final Map<String, Group> _groups = {};
  final List<TimelineEvent> _timeline = [];

  List<Group> get groups => _groups.values.toList();

  List<Group> get managedGroups =>
      _groups.values.where((g) => g.adminId == currentAdminId).toList();

  List<Group> get joinedGroups => _groups.values
      .where((g) => g.membershipFor(currentMemberId) != null)
      .toList();

  Group? group(String groupId) => _groups[groupId];

  Member? member(String memberId) => _members[memberId];

  /// Reads from the local cache — call loadTimeline(groupId) first to
  /// populate it (TimelineScreen does this in initState).
  List<TimelineEvent> timelineFor(String groupId) => _timeline
      .where((e) => e.groupId == groupId)
      .toList()
      .reversed
      .toList(); // most recent first

  /// Bridges the real signed-in Supabase user into this repo's stand-in
  /// fields, then loads their groups. Call right after signup (Role
  /// Selection) or right after sign-in fetches the profile.
  Future<void> syncCurrentUser({
    required String userId,
    required String accountType,
    required String fullName,
  }) async {
    currentAccountType = accountType;
    currentUserName = fullName;
    if (accountType == 'admin') {
      currentAdminId = userId;
    } else {
      currentMemberId = userId;
    }
    notifyListeners();
    await loadGroups();
  }

  /// Call from the Logout action, BEFORE navigating back to splash.
  /// Unlike the mock-data era, this now clears cached data too — this is
  /// real account data, and leaving it in memory would let a second
  /// account on the same device briefly see the previous account's
  /// groups before loadGroups() finishes on their sign-in.
  void resetForLogout() {
    currentAccountType = 'admin';
    currentMemberId = '';
    currentAdminId = '';
    currentUserName = 'User';
    _groups.clear();
    _members.clear();
    _timeline.clear();
    notifyListeners();
  }

  // ---- Supabase-backed reads ----

  /// Fetches every group the current user manages (admin) or belongs to
  /// (member), plus their members and this-cycle payment status, in a
  /// fixed small number of batched queries — not one query per group.
  Future<void> loadGroups() async {
    isLoading = true;
    loadError = null;
    notifyListeners();

    try {
      final List<Map<String, dynamic>> groupRows;
      if (currentAccountType == 'admin') {
        groupRows = await _supabase
            .from('groups')
            .select()
            .eq('admin_id', currentAdminId);
      } else {
        final memberRows = await _supabase
            .from('group_members')
            .select('group_id')
            .eq('user_id', currentMemberId);
        final groupIds =
            memberRows.map((r) => r['group_id'] as String).toSet().toList();
        groupRows = groupIds.isEmpty
            ? <Map<String, dynamic>>[]
            : await _supabase.from('groups').select().inFilter('id', groupIds);
      }

      if (groupRows.isEmpty) {
        _groups.clear();
        isLoading = false;
        notifyListeners();
        return;
      }

      final groupIds = groupRows.map((r) => r['id'] as String).toList();
      final cycleByGroup = {
        for (final r in groupRows) r['id'] as String: r['current_cycle_number'] as int
      };

      // One query for every membership row across all these groups.
      final memberRows = await _supabase
          .from('group_members')
          .select('group_id, user_id, payout_position, dva_account_number')
          .inFilter('group_id', groupIds)
          .order('payout_position');

      final userIds = memberRows.map((r) => r['user_id'] as String).toSet().toList();
      final userRows = userIds.isEmpty
          ? <Map<String, dynamic>>[]
          : await _supabase.from('users').select('id, full_name').inFilter('id', userIds);
      for (final u in userRows) {
        _members[u['id'] as String] =
            Member(id: u['id'] as String, name: u['full_name'] as String? ?? 'Unnamed');
      }

      // One query for every paid contribution across all these groups —
      // grouped locally per group below, filtered to that group's own
      // current cycle (each group can be on a different cycle number).
      final contributionRows = await _supabase
          .from('contributions')
          .select('group_id, user_id, cycle_number')
          .inFilter('group_id', groupIds)
          .eq('status', 'paid');

      final newGroups = <String, Group>{};
      for (final row in groupRows) {
        final groupId = row['id'] as String;
        final currentCycle = cycleByGroup[groupId]!;

        final thisGroupMembers =
            memberRows.where((r) => r['group_id'] == groupId).toList();

        final thisCyclePaidCount = <String, int>{};
        for (final c in contributionRows) {
          if (c['group_id'] != groupId) continue;
          if (c['cycle_number'] != currentCycle) continue;
          final uid = c['user_id'] as String;
          thisCyclePaidCount[uid] = (thisCyclePaidCount[uid] ?? 0) + 1;
        }

        final memberships = thisGroupMembers.map((r) {
          final uid = r['user_id'] as String;
          final paidCount = thisCyclePaidCount[uid] ?? 0;
          return GroupMembership(
            memberId: uid,
            dvaAccountNumber: r['dva_account_number'] as String? ?? '',
            currentCycleStatus:
                paidCount > 0 ? ContributionStatus.paid : ContributionStatus.pending,
            contributionsPaidThisCycle: paidCount,
          );
        }).toList();

        newGroups[groupId] = Group(
          id: groupId,
          name: row['name'] as String,
          adminId: row['admin_id'] as String,
          contributionAmount: row['contribution_amount'] as num,
          frequency: _frequencyFromString(row['frequency'] as String),
          payoutAmount: row['payout_amount'] as num,
          riskThresholdPercent: row['risk_threshold_percent'] as int,
          payoutRotation: thisGroupMembers.map((r) => r['user_id'] as String).toList(),
          memberships: memberships,
          currentCycleNumber: currentCycle,
        );
      }

      _groups
        ..clear()
        ..addAll(newGroups);
    } catch (e) {
      loadError = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Refetches a single group — used after a mutation instead of
  /// reloading the whole list. Reuses loadGroups' query shape, scoped to one id.
  Future<void> refreshGroup(String groupId) async {
    try {
      final row =
          await _supabase.from('groups').select().eq('id', groupId).single();
      final currentCycle = row['current_cycle_number'] as int;

      final memberRows = await _supabase
          .from('group_members')
          .select('user_id, payout_position, dva_account_number')
          .eq('group_id', groupId)
          .order('payout_position');

      final userIds = memberRows.map((r) => r['user_id'] as String).toSet().toList();
      final userRows = userIds.isEmpty
          ? <Map<String, dynamic>>[]
          : await _supabase.from('users').select('id, full_name').inFilter('id', userIds);
      for (final u in userRows) {
        _members[u['id'] as String] =
            Member(id: u['id'] as String, name: u['full_name'] as String? ?? 'Unnamed');
      }

      final contributionRows = await _supabase
          .from('contributions')
          .select('user_id')
          .eq('group_id', groupId)
          .eq('cycle_number', currentCycle)
          .eq('status', 'paid');

      final paidCount = <String, int>{};
      for (final c in contributionRows) {
        final uid = c['user_id'] as String;
        paidCount[uid] = (paidCount[uid] ?? 0) + 1;
      }

      final memberships = memberRows.map((r) {
        final uid = r['user_id'] as String;
        final count = paidCount[uid] ?? 0;
        return GroupMembership(
          memberId: uid,
          dvaAccountNumber: r['dva_account_number'] as String? ?? '',
          currentCycleStatus:
              count > 0 ? ContributionStatus.paid : ContributionStatus.pending,
          contributionsPaidThisCycle: count,
        );
      }).toList();

      _groups[groupId] = Group(
        id: groupId,
        name: row['name'] as String,
        adminId: row['admin_id'] as String,
        contributionAmount: row['contribution_amount'] as num,
        frequency: _frequencyFromString(row['frequency'] as String),
        payoutAmount: row['payout_amount'] as num,
        riskThresholdPercent: row['risk_threshold_percent'] as int,
        payoutRotation: memberRows.map((r) => r['user_id'] as String).toList(),
        memberships: memberships,
        currentCycleNumber: currentCycle,
      );

      notifyListeners();
    } catch (e) {
      loadError = e.toString();
      notifyListeners();
    }
  }

  /// Fetches this group's timeline into the local cache — call from
  /// TimelineScreen's initState before reading timelineFor(groupId).
  Future<void> loadTimeline(String groupId) async {
    try {
      final rows = await _supabase
          .from('timeline_events')
          .select()
          .eq('group_id', groupId)
          .order('created_at');

      _timeline.removeWhere((e) => e.groupId == groupId);
      _timeline.addAll(rows.map((r) => TimelineEvent(
            groupId: r['group_id'] as String,
            type: _timelineTypeFromString(r['type'] as String),
            timestamp: DateTime.parse(r['created_at'] as String),
            message: r['message'] as String,
          )));
      notifyListeners();
    } catch (e) {
      loadError = e.toString();
      notifyListeners();
    }
  }

  // ---- Supabase-backed writes ----

  /// Creates a new group owned by currentAdminId, with no members yet.
  /// Returns the new group's id.
  Future<String> createGroup({
    required String name,
    required num contributionAmount,
    required GroupFrequency frequency,
    required num payoutAmount,
    required int riskThresholdPercent,
  }) async {
    final row = await _supabase
        .from('groups')
        .insert({
          'admin_id': currentAdminId,
          'name': name,
          'contribution_amount': contributionAmount,
          'frequency': frequency.label,
          'payout_amount': payoutAmount,
          'risk_threshold_percent': riskThresholdPercent,
          'current_cycle_number': 1,
          'status': 'active',
        })
        .select('id')
        .single();

    final id = row['id'] as String;

    // No members yet — build locally rather than round-tripping.
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

  /// Looks up a group by invite code (currently just the group's id — see
  /// class docs on Group re: no separate invite_code column yet) without
  /// joining, for JoinGroupScreen's preview step.
  Future<Group?> previewGroupByInviteCode(String inviteCode) async {
    final row = await _supabase
        .from('groups')
        .select()
        .eq('id', inviteCode)
        .maybeSingle();
    if (row == null) return null;

    // Preview doesn't need full membership detail — a lightweight Group
    // with an empty membership list is enough for JoinGroupScreen to show
    // name/amount/frequency before the user confirms.
    return Group(
      id: row['id'] as String,
      name: row['name'] as String,
      adminId: row['admin_id'] as String,
      contributionAmount: row['contribution_amount'] as num,
      frequency: _frequencyFromString(row['frequency'] as String),
      payoutAmount: row['payout_amount'] as num,
      riskThresholdPercent: row['risk_threshold_percent'] as int,
      payoutRotation: const [],
      memberships: const [],
      currentCycleNumber: row['current_cycle_number'] as int,
    );
  }

  /// Joins currentMemberId to the group matching inviteCode. Returns the
  /// joined Group, or null if the code doesn't match any group. Safe to
  /// call twice — if already a member, just returns the group as-is.
  Future<Group?> joinGroup(String inviteCode) async {
    final existing = await _supabase
        .from('group_members')
        .select()
        .eq('group_id', inviteCode)
        .eq('user_id', currentMemberId)
        .maybeSingle();

    if (existing == null) {
      final countRow = await _supabase
          .from('group_members')
          .select('user_id')
          .eq('group_id', inviteCode);
      final nextPosition = countRow.length;

      await _supabase.from('group_members').insert({
        'group_id': inviteCode,
        'user_id': currentMemberId,
        'payout_position': nextPosition,
        'dva_account_number': _generateDvaAccountNumber(),
      });

      await _supabase.from('timeline_events').insert({
        'group_id': inviteCode,
        'type': 'memberJoined',
        'message': '$currentUserName joined the group',
      });
    }

    await refreshGroup(inviteCode);
    return _groups[inviteCode];
  }

  /// Simulates a Paystack DVA webhook — the real webhook isn't built yet,
  /// so this is a manual "simulate payment" action in the admin UI. Inserts
  /// a real contribution row with a placeholder reference so the flow is
  /// testable end-to-end before Paystack is wired up.
  Future<void> recordContributionPaid(
    String groupId,
    String memberId,
    num amount,
  ) async {
    final group = _groups[groupId];
    if (group == null) return;

    await _supabase.from('contributions').insert({
      'group_id': groupId,
      'user_id': memberId,
      'cycle_number': group.currentCycleNumber,
      'amount': amount,
      'paystack_reference': 'SIMULATED-${DateTime.now().millisecondsSinceEpoch}',
      'status': 'paid',
      'paid_at': DateTime.now().toIso8601String(),
    });

    final memberName = _members[memberId]?.name ?? 'Unknown';
    await _supabase.from('timeline_events').insert({
      'group_id': groupId,
      'type': 'paymentReceived',
      'message': '$memberName paid ₦$amount',
    });

    await refreshGroup(groupId);
  }

  String _generateDvaAccountNumber() {
    final seed = DateTime.now().millisecondsSinceEpoch % 1000000000;
    return '90${seed.toString().padLeft(8, '0')}';
  }

  GroupFrequency _frequencyFromString(String value) => switch (value) {
        'daily' => GroupFrequency.daily,
        'weekly' => GroupFrequency.weekly,
        'monthly' => GroupFrequency.monthly,
        _ => throw ArgumentError('Unknown frequency: $value'),
      };

  TimelineEventType _timelineTypeFromString(String value) => switch (value) {
        'paymentReceived' => TimelineEventType.paymentReceived,
        'paymentMissed' => TimelineEventType.paymentMissed,
        'payoutCompleted' => TimelineEventType.payoutCompleted,
        'memberJoined' => TimelineEventType.memberJoined,
        'memberRemoved' => TimelineEventType.memberRemoved,
        _ => throw ArgumentError('Unknown timeline event type: $value'),
      };
}
