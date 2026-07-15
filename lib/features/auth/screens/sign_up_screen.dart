import 'package:flutter/material.dart';

import '../../../routes/app_router.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/primary_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _nameError;
  String? _phoneError;
  String? _passwordError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create account')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacing24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to Ajo Hub',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: AppTheme.spacing8),
                Text(
                  'Create your account in a few steps.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppTheme.spacing24),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Full name'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppTheme.spacing16),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Phone number'),
                  validator: (value) {
                    if (value == null || value.trim().length < 10) {
                      return 'Phone number should be at least 10 digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppTheme.spacing16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppTheme.spacing24),
                if (_nameError != null ||
                    _phoneError != null ||
                    _passwordError != null)
                  Container(
                    padding: const EdgeInsets.all(AppTheme.spacing12),
                    decoration: BoxDecoration(
                      color: AppTheme.accent,
                      borderRadius: BorderRadius.circular(AppTheme.radius12),
                    ),
                    child: Text(
                      [
                        _nameError,
                        _phoneError,
                        _passwordError,
                      ].whereType<String>().join('\n'),
                      style: const TextStyle(color: AppTheme.primary),
                    ),
                  ),
                const SizedBox(height: AppTheme.spacing24),
                PrimaryButton(label: 'Continue', onPressed: _submit),
                const SizedBox(height: AppTheme.spacing12),
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed(AppRoutes.signIn),
                  child: const Text('Already have an account?'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    setState(() {
      _nameError = null;
      _phoneError = null;
      _passwordError = null;
    });

    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pushNamed(AppRoutes.otp);
    }
  }
}
