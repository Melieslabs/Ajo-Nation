import 'package:flutter/material.dart';

import '../../../routes/app_router.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/primary_button.dart';

class KycSetupScreen extends StatefulWidget {
  const KycSetupScreen({super.key});

  @override
  State<KycSetupScreen> createState() => _KycSetupScreenState();
}

class _KycSetupScreenState extends State<KycSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _bankName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bank details')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacing24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Secure your payouts',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: AppTheme.spacing8),
                Text(
                  'This is a mock setup screen for the UI flow.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppTheme.spacing24),
                DropdownButtonFormField<String>(
                  initialValue: _bankName,
                  decoration: const InputDecoration(labelText: 'Bank name'),
                  items: ['Access Bank', 'GTBank', 'Zenith Bank', 'UBA']
                      .map(
                        (bank) =>
                            DropdownMenuItem(value: bank, child: Text(bank)),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => _bankName = value),
                ),
                const SizedBox(height: AppTheme.spacing16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Account number',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => (value == null || value.length < 10)
                      ? 'Enter a valid account number'
                      : null,
                ),
                const SizedBox(height: AppTheme.spacing16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'BVN'),
                  keyboardType: TextInputType.number,
                  validator: (value) => (value == null || value.length < 11)
                      ? 'Enter your 11-digit BVN'
                      : null,
                ),
                const SizedBox(height: AppTheme.spacing24),
                PrimaryButton(label: 'Finish setup', onPressed: _submit),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    }
  }
}
