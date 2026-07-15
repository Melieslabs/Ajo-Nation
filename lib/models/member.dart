/// A person's identity, independent of any group they belong to.
/// Group-specific data (DVA, payment status, position in rotation) lives
/// on [GroupMembership], not here — a member can belong to multiple groups.
class Member {
  const Member({required this.id, required this.name});

  final String id;
  final String name;

  /// Two-letter initials for avatar display, e.g. "Nneka Okafor" -> "NO".
  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }
}
