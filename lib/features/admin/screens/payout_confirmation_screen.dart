import 'package:flutter/material.dart';

import '../../../data/mock_data_repository.dart';
import '../../../routes/app_router.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/primary_button.dart';

class PayoutConfirmationScreen extends StatefulWidget {
  const PayoutConfirmationScreen({super.key, required this.groupId});

  final String groupId;

  @override
  State<PayoutConfirmationScreen> createState() => _PayoutConfirmationScreenState();
}

class _PayoutConfirmationScreenState extends State<PayoutConfirmationScreen> {
  final _repo = MockDataRepository.instance;

  bool _isConfirming = false;
  bool _completed = false;
  String? _error;
  String? _paidRecipientName;

  Future<void> _confirm() async {
    if (_isConfirming) return; // guard against double-tap
    setState(() {
      _isConfirming = true;
      _error = null;
    });

    try {
      final recipientName = await _repo.triggerPayout(widget.groupId);
      if (!mounted) return;
      setState(() {
        _isConfirming = false;
        _completed = true;
        _paidRecipientName = recipientName;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isConfirming = false;
        _error = 'Couldn\'t process the payout: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final group = _repo.group(widget.groupId);

    if (group == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Trigger payout')),
        body: const Center(child: Text('This group no longer exists.')),
      );
    }

    final recipient = group.currentRecipient;
    final recipientName = recipient != null
        ? _repo.member(recipient.memberId)?.name ?? 'Unknown'
        : null;

    if (_completed) {
      return Scaffold(
        appBar: AppBar(title: const Text('Payout completed')),
        body: Padding(
          padding: const EdgeInsets.all(AppTheme.spacing24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.check_circle, color: AppTheme.primary, size: 56),
              const SizedBox(height: AppTheme.spacing16),
              Text('Payout sent', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: AppTheme.spacing24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacing16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Recipient: $_paidRecipientName',
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: AppTheme.spacing8),
                      Text('Amount: ₦${group.payoutAmount}',
                          style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacing24),
              PrimaryButton(
                label: 'Back to dashboard',
                onPressed: () => Navigator.of(context)
                    .pushNamedAndRemoveUntil(AppRoutes.home, (route) => false),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Trigger payout')),
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (recipientName == null) ...[
              Text(
                'Everyone in this group has already received a payout this rotation.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ] else ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacing16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Recipient', style: Theme.of(context).textTheme.labelLarge),
                      const SizedBox(height: AppTheme.spacing4),
                      Text(recipientName, style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: AppTheme.spacing16),
                      Text('Amount', style: Theme.of(context).textTheme.labelLarge),
                      const SizedBox(height: AppTheme.spacing4),
                      Text('₦${group.payoutAmount}', style: Theme.of(context).textTheme.headlineSmall),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacing24),
              if (_error != null) ...[
                Text(_error!, style: TextStyle(color: AppTheme.danger)),
                const SizedBox(height: AppTheme.spacing12),
              ],
              PrimaryButton(
                label: _isConfirming ? 'Processing...' : 'Confirm',
                onPressed: () => _confirm(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
