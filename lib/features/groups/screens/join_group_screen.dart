import 'package:flutter/material.dart';

import '../../../data/mock_data_repository.dart';
import '../../../models/group.dart';
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

  Group? _previewedGroup;
  bool _codeNotFound = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handlePreview() {
    final code = _controller.text.trim();
    final group = MockDataRepository.instance.previewGroupByInviteCode(code);

    setState(() {
      _previewedGroup = group;
      _codeNotFound = group == null && code.isNotEmpty;
    });
  }

  void _handleConfirmJoin() {
    final code = _controller.text.trim();
    final joined = MockDataRepository.instance.joinGroup(code);
    if (joined == null) return;
    Navigator.of(context).pop(joined.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Join group')),
      body: SafeArea(
        child: Padding(
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
                decoration: InputDecoration(
                  labelText: 'Invite code',
                  errorText: _codeNotFound ? 'No group found for this code' : null,
                ),
                onChanged: (_) {
                  // Clear a stale preview/error as soon as they start editing
                  // the code again, rather than leaving old data on screen.
                  if (_previewedGroup != null || _codeNotFound) {
                    setState(() {
                      _previewedGroup = null;
                      _codeNotFound = false;
                    });
                  }
                },
              ),
              const SizedBox(height: AppTheme.spacing16),

              PrimaryButton(label: 'Preview group', onPressed: _handlePreview),

              if (_previewedGroup != null) ...[
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
                        Text(
                          '${_previewedGroup!.name} • ₦${_previewedGroup!.contributionAmount} '
                          '${_previewedGroup!.frequency.label}',
                        ),
                        const SizedBox(height: AppTheme.spacing8),
                        Text('${_previewedGroup!.totalMembers} members'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacing16),
                PrimaryButton(label: 'Confirm join', onPressed: _handleConfirmJoin),
                const SizedBox(height: AppTheme.spacing12),
                SecondaryButton(
                  label: 'Cancel',
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}