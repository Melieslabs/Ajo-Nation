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
  bool _isSearching = false;
  bool _isJoining = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handlePreview() async {
    final code = _controller.text.trim();
    setState(() {
      _isSearching = true;
      _error = null;
    });

    try {
      final group = await MockDataRepository.instance.previewGroupByInviteCode(code);
      if (!mounted) return;
      setState(() {
        _previewedGroup = group;
        _codeNotFound = group == null && code.isNotEmpty;
        _isSearching = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSearching = false;
        _error = 'Couldn\'t look up that code: $e';
      });
    }
  }

  Future<void> _handleConfirmJoin() async {
    if (_isJoining) return; // guard against double-tap
    final code = _controller.text.trim();
    setState(() {
      _isJoining = true;
      _error = null;
    });

    try {
      final joined = await MockDataRepository.instance.joinGroup(code);
      if (!mounted) return;
      if (joined == null) {
        setState(() {
          _isJoining = false;
          _error = 'That code no longer matches a group.';
        });
        return;
      }
      Navigator.of(context).pop(joined.id);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isJoining = false;
        _error = 'Couldn\'t join that group: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Join group')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacing24),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
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
            
                PrimaryButton(
                  label: _isSearching ? 'Searching...' : 'Preview group',
                  onPressed: () => _handlePreview(),
                ),
            
                if (_error != null) ...[
                  const SizedBox(height: AppTheme.spacing12),
                  Text(_error!, style: TextStyle(color: AppTheme.danger)),
                ],
            
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
                  PrimaryButton(
                    label: _isJoining ? 'Joining...' : 'Confirm join',
                    onPressed: () => _handleConfirmJoin(),
                  ),
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
      ),
    );
  }
}