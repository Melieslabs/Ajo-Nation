import 'package:flutter/material.dart';

import '../../../data/mock_data_repository.dart';
import '../../../models/group.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/risk_threshold_dropdown.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _contributionController = TextEditingController();
  final _payoutController = TextEditingController();

  GroupFrequency _frequency = GroupFrequency.monthly;
  int _riskThreshold = 50;

  @override
  void dispose() {
    _nameController.dispose();
    _contributionController.dispose();
    _payoutController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (!_formKey.currentState!.validate()) return;

    final groupId = MockDataRepository.instance.createGroup(
      name: _nameController.text.trim(),
      contributionAmount: num.parse(_contributionController.text),
      frequency: _frequency,
      payoutAmount: num.parse(_payoutController.text),
      riskThresholdPercent: _riskThreshold,
    );

    // Return the new group's id so the caller (Groups tab) can navigate
    // straight to it if it wants to — Navigator.pop with a result.
    Navigator.of(context).pop(groupId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create group')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacing24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create a new Ajo group',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: AppTheme.spacing24),

                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Group name'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Enter a group name' : null,
                ),
                const SizedBox(height: AppTheme.spacing16),

                TextFormField(
                  controller: _contributionController,
                  decoration: const InputDecoration(
                    labelText: 'Contribution amount (₦)',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Enter an amount';
                    if (num.tryParse(v) == null) return 'Enter a valid number';
                    return null;
                  },
                ),
                const SizedBox(height: AppTheme.spacing16),

                // Fixed-choice dropdown, not free text — frequency is one of
                // daily/weekly/monthly, matching GroupFrequency.
                DropdownButtonFormField<GroupFrequency>(
                  initialValue: _frequency,
                  decoration: const InputDecoration(labelText: 'Frequency'),
                  items: GroupFrequency.values
                      .map((f) => DropdownMenuItem(
                            value: f,
                            child: Text(f.label[0].toUpperCase() + f.label.substring(1)),
                          ))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => _frequency = v);
                  },
                ),
                const SizedBox(height: AppTheme.spacing16),

                TextFormField(
                  controller: _payoutController,
                  decoration: const InputDecoration(
                    labelText: 'Payout amount (₦)',
                    helperText: 'What the recipient collects on their turn',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Enter a payout amount';
                    if (num.tryParse(v) == null) return 'Enter a valid number';
                    return null;
                  },
                ),
                const SizedBox(height: AppTheme.spacing24),

                RiskThresholdDropdown(
                  value: _riskThreshold,
                  onChanged: (v) => setState(() => _riskThreshold = v),
                ),
                const SizedBox(height: AppTheme.spacing24),

                PrimaryButton(label: 'Save group', onPressed: _handleSave),
              ],
            ),
          ),
        ),
      ),
    );
  }
}