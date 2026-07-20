import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/mock_data_repository.dart';
import '../../../routes/app_router.dart';
import '../../../services/auth_service.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/primary_button.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Null while still checking for an existing session. Once resolved,
  // either this screen never actually gets shown (we navigate away) or
  // it's shown with _checkingSession = false, buttons visible.
  bool _checkingSession = true;

  @override
  void initState() {
    super.initState();
    _checkExistingSession();
  }

  Future<void> _checkExistingSession() async {
    // Supabase persists sessions locally by default — Supabase.initialize()
    // in main() already restored it by the time this runs, so this is a
    // synchronous check, not a network call.
    if (!AuthService.instance.isSignedIn) {
      if (mounted) setState(() => _checkingSession = false);
      return;
    }

    try {
      final profile = await AuthService.instance.fetchUserProfile();
      await MockDataRepository.instance.syncCurrentUser(
        userId: AuthService.instance.currentUserId!,
        accountType: profile.accountType,
        fullName: profile.fullName,
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    } on PostgrestException {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(AppRoutes.roleSelection);
    } catch (_) {
      if (mounted) setState(() => _checkingSession = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_checkingSession) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppTheme.spacing24),
              decoration: BoxDecoration(
                color: AppTheme.accent,
                borderRadius: BorderRadius.circular(AppTheme.radius16),
              ),
              child: FaIcon(
                FontAwesomeIcons.piggyBank,
                size: 56,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: AppTheme.spacing24),
            Text('Ajo Hub', style: Theme.of(context).textTheme.displaySmall),
            const SizedBox(height: AppTheme.spacing8),
            Text(
              'Rotating savings, simplified',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 300),
            PrimaryButton(
              label: 'Get started',
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.onboarding),
            ),
            const SizedBox(height: AppTheme.spacing12),
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.signIn),
              child: const Text('Already have an account? Sign in'),
            ),
          ],
        ),
      ),
    );
  }
}