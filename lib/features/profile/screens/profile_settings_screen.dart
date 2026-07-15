import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

class ProfileSettingsScreen extends StatelessWidget {
  const ProfileSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile & settings')),
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing24),
        child: ListView(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(child: Text('AM')),
              title: const Text('Amina Musa'),
              subtitle: const Text('Ambassador • Admin'),
            ),
            const SizedBox(height: AppTheme.spacing16),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit profile'),
            ),
            ListTile(
              leading: const Icon(Icons.account_balance),
              title: const Text('Bank details'),
            ),
            ListTile(
              leading: const Icon(Icons.brightness_6),
              title: const Text('Theme'),
              subtitle: const Text('Coming soon'),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
