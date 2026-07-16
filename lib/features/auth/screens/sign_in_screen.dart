import 'package:flutter/material.dart';

import '../../../data/mock_data_repository.dart';
import '../../../routes/app_router.dart';
import '../../../services/auth_service.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/primary_button.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isSubmitting = false;
  String? _submitError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign in')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacing24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: AppTheme.spacing8),
                Text(
                  'Access your groups and updates.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppTheme.spacing24),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || !value.contains('@')) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppTheme.spacing16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (value) => (value == null || value.length < 6)
                      ? 'Enter your password'
                      : null,
                ),
                const SizedBox(height: AppTheme.spacing24),
                if (_submitError != null)
                  Container(
                    padding: const EdgeInsets.all(AppTheme.spacing12),
                    decoration: BoxDecoration(
                      color: AppTheme.accent,
                      borderRadius: BorderRadius.circular(AppTheme.radius12),
                    ),
                    child: Text(
                      _submitError!,
                      style: TextStyle(color: AppTheme.primary),
                    ),
                  ),
                const SizedBox(height: AppTheme.spacing24),
                PrimaryButton(
                  label: _isSubmitting ? 'Signing in...' : 'Sign in',
                  onPressed: () => _submit(),
                ),
                const SizedBox(height: AppTheme.spacing12),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Create account'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (_isSubmitting) return; // guard against double-tap, since onPressed can't be null'd out

    setState(() => _submitError = null);

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      await AuthService.instance.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Existing accounts already have account_type + name set from
      // their original sign-up — fetch both so AppRouter's /home check
      // sends them to the correct dashboard, AND Profile shows their
      // real name instead of a placeholder.
      final profile = await AuthService.instance.fetchUserProfile();
      await MockDataRepository.instance.syncCurrentUser(
        userId: AuthService.instance.currentUserId!,
        accountType: profile.accountType,
        fullName: profile.fullName,
      );

      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _submitError = friendlyAuthError(e);
      });
    }
  }
}