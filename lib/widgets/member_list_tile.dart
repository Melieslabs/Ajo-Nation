import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'status_badge.dart';

class MemberListTile extends StatelessWidget {
  const MemberListTile({
    super.key,
    required this.name,
    required this.initials,
    required this.status,
    this.trailing,
  });

  final String name;
  final String initials;
  final StatusVariant status;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: AppTheme.accent,
        child: Text(
          initials,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      title: Text(name, style: Theme.of(context).textTheme.titleMedium),
      trailing:
          trailing ??
          StatusBadge(label: _labelForStatus(status), variant: status),
    );
  }

  String _labelForStatus(StatusVariant status) {
    return switch (status) {
      StatusVariant.paid => 'Paid',
      StatusVariant.pending => 'Pending',
      StatusVariant.late => 'Late',
    };
  }
}
