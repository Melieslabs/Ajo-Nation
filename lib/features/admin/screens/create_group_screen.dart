import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/primary_button.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _formKey = GlobalKey<FormState>();

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
                  decoration: const InputDecoration(labelText: 'Group name'),
                ),
                const SizedBox(height: AppTheme.spacing16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Contribution amount',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: AppTheme.spacing16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Frequency'),
                ),
                const SizedBox(height: AppTheme.spacing16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Cycle length'),
                ),
                const SizedBox(height: AppTheme.spacing16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Target amount'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: AppTheme.spacing24),
                PrimaryButton(
                  label: 'Save group',
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
