import 'package:flutter/material.dart';

import '../../../data/mock_data_repository.dart';
import '../../../models/group.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/status_badge.dart';

class PaymentInfoScreen extends StatelessWidget {
  const PaymentInfoScreen({
    super.key,
    required this.groupId,
  });

  final String groupId;

  @override
  Widget build(BuildContext context) {
    final repo = MockDataRepository.instance;

    final group = repo.group(groupId);

    if (group == null) {
      return const Scaffold(
        body: Center(
          child: Text('Group not found'),
        ),
      );
    }

    final membership = group.membershipFor(repo.currentMemberId);

    if (membership == null) {
      return const Scaffold(
        body: Center(
          child: Text('Membership not found'),
        ),
      );
    }

    final isPaid = membership.currentCycleStatus == ContributionStatus.paid;
    final recipient = group.currentRecipient;
    final recipientName = recipient != null
        ? repo.member(recipient.memberId)?.name ?? 'Unknown'
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacing24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (recipientName != null) ...[
              Text(
                "This cycle's recipient",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppTheme.spacing12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppTheme.spacing16),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(AppTheme.radius16),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppTheme.primarySoft,
                      child: Icon(Icons.person, color: AppTheme.primary),
                    ),
                    const SizedBox(width: AppTheme.spacing12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(recipientName,
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppTheme.textPrimary)),
                          const SizedBox(height: AppTheme.spacing4),
                          Text(
                            "Everyone's contributions will be paid to $recipientName after this cycle closes.",
                            style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacing24),
            ],
            Text(
              'Current Cycle',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppTheme.spacing16),
            Card(
              elevation: 0,
              color: AppTheme.primary.withValues(alpha: .08),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide(
                  color: AppTheme.primary.withValues(alpha: .15),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    /// LEFT SIDE
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Amount Due',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 8),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '₦',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                        color: AppTheme.primary,
                                      ),
                                ),
                                TextSpan(
                                  text: '${group.contributionAmount}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Status',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 8),
                          StatusBadge(
                            label: isPaid ? 'Paid' : 'Pending',
                            variant: isPaid
                                ? StatusVariant.paid
                                : StatusVariant.pending,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Cycle ${group.currentCycleNumber}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 24),

                    /// Divider
                    Container(
                      width: 1,
                      height: 180,
                      color: Colors.white10,
                    ),

                    const SizedBox(width: 24),

                    /// RIGHT SIDE
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 72,
                            width: 72,
                            decoration: BoxDecoration(
                              color: isPaid ? AppTheme.primary : Colors.orange,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isPaid
                                  ? Icons.check_rounded
                                  : Icons.schedule_rounded,
                              size: 38,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            isPaid ? 'Payment\nReceived' : 'Awaiting\nPayment',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'Dedicated Virtual Account',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radius16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacing20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bank',
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Moniepoint',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Account Number',
                    ),
                    const SizedBox(height: 4),
                    SelectableText(
                      membership.dvaAccountNumber,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Transfer exactly ₦${group.contributionAmount} into this account.',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'How it works',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            const Text(
              '• Transfer the exact contribution amount.\n\n'
              '• Your payment will be confirmed automatically.\n\n'
              '• Once confirmed, your contribution status updates immediately.\n\n'
              '• Your payment will appear in the group timeline.',
            ),
            const SizedBox(height: 36),
            PrimaryButton(
              label: 'Copy Account Number',
              onPressed: () {
                // TODO: Clipboard.setData(...)
              },
            ),
            const SizedBox(height: 16),
            if (!isPaid)
              PrimaryButton(
                label: 'Simulate Payment',
                onPressed: () async {
                  await repo.payContribution(group.id);

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppTheme.spacing20),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(
                    AppTheme.radius16,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: AppTheme.primary,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Your contribution has already been received for this cycle.',
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
