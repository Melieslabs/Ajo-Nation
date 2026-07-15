import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/secondary_button.dart';

class JoinGroupScreen extends StatefulWidget {
  const JoinGroupScreen({super.key});

  @override
  State<JoinGroupScreen> createState() => _JoinGroupScreenState();
}

class _JoinGroupScreenState extends State<JoinGroupScreen> {
  final _controller = TextEditingController();
  bool _previewVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Join group')),
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter invite code',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppTheme.spacing8),
            Text(
              'Use the code shared with you by your group admin.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppTheme.spacing24),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Invite code'),
            ),
            const SizedBox(height: AppTheme.spacing16),
            PrimaryButton(
              label: 'Preview group',
              onPressed: () => setState(() => _previewVisible = true),
            ),
            if (_previewVisible) ...[
              const SizedBox(height: AppTheme.spacing24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacing16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Group preview',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppTheme.spacing8),
                      Text('Community Ajo • ₦20,000 weekly'),
                      const SizedBox(height: AppTheme.spacing8),
                      Text('7 members • 4 cycles left'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacing16),
              PrimaryButton(label: 'Confirm join', onPressed: () {}),
              const SizedBox(height: AppTheme.spacing12),
              SecondaryButton(
                label: 'Cancel',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
