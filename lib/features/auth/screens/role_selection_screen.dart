import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../data/mock_data_repository.dart';
import '../../../routes/app_router.dart';
import '../../../services/auth_service.dart';
import '../../../theme/app_theme.dart';

/// The one place account_type ever gets set. Reached once, during sign-up
/// — never revisited, never toggled. Writes the permanent `users` row via
/// AuthService.completeSignup(), then syncs MockDataRepository (which now
/// loads real group data from Supabase) and routes into the matching home
/// shell.
class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  bool _isSubmitting = false;

  Future<void> _choose(String accountType) async {
    if (_isSubmitting) return; // guard against double-tap while awaiting
    setState(() => _isSubmitting = true);

    try {
      // Captured BEFORE completeSignup() runs — that method clears
      // pendingFullName right after inserting the users row, so it must
      // be read here first or it'd be null by the time we need it below.
      final fullName = AuthService.instance.pendingFullName ?? 'Unnamed user';

      await AuthService.instance.completeSignup(accountType: accountType);

      // Bridges the real signed-in id AND name into the repo, then loads
      // this (brand new) admin/member's groups — empty at this point,
      // but keeps behavior consistent with sign-in.
      await MockDataRepository.instance.syncCurrentUser(
        userId: AuthService.instance.currentUserId!,
        accountType: accountType,
        fullName: fullName,
      );

      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.home,
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(friendlyAuthError(e))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacing24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'How do you want to\nuse Ajo Hub?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  height: 1.2,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: AppTheme.spacing8),
              Text(
                'This can\'t be changed later, so pick the one that matches you.',
                style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: AppTheme.spacing32),

              _roleCard(
                icon: FontAwesomeIcons.userTie,
                title: 'I manage groups',
                subtitle: 'You collect contributions and run the payout rotation',
                onTap: () => _choose('admin'),
              ),
              const SizedBox(height: AppTheme.spacing16),
              _roleCard(
                icon: FontAwesomeIcons.users,
                title: 'I\'m in groups',
                subtitle: 'You join circles run by someone else and make contributions',
                onTap: () => _choose('member'),
              ),

              if (_isSubmitting) ...[
                const SizedBox(height: AppTheme.spacing24),
                Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _roleCard({
    required FaIconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: _isSubmitting ? null : onTap,
      child: Opacity(
        opacity: _isSubmitting ? 0.5 : 1.0,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppTheme.spacing20),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(AppTheme.radius20),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.pasteGreen,
                  borderRadius: BorderRadius.circular(AppTheme.radius16),
                ),
                child: Center(child: FaIcon(icon, size: 20, color: AppTheme.primary)),
              ),
              const SizedBox(width: AppTheme.spacing16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: AppTheme.textPrimary,
                        )),
                    const SizedBox(height: 4),
                    Text(subtitle,
                        style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                  ],
                ),
              ),
              FaIcon(FontAwesomeIcons.chevronRight, size: 16, color: AppTheme.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}