import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing24),
        child: ListView(
          children: [
            _notificationTile(
              'Payment reminder',
              'Your contribution for Community Ajo is due tomorrow',
              true,
            ),
            _notificationTile(
              'Payout alert',
              'A payout was processed for Ajo Circle',
              false,
            ),
            _notificationTile(
              'Late payment flag',
              'Dayo Bassey is marked late for this cycle',
              true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _notificationTile(String title, String message, bool unread) {
    return Card(
      child: ListTile(
        leading: Icon(
          unread ? Icons.circle : Icons.check_circle_outline,
          color: unread ? AppTheme.primary : AppTheme.textSecondary,
        ),
        title: Text(title),
        subtitle: Text(message),
      ),
    );
  }
}
