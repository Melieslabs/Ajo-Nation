import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../data/mock_data_repository.dart';
import '../../../routes/app_router.dart';
import '../../../theme/app_theme.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  void _choose(BuildContext context, String accountType) {
    MockDataRepository.instance.currentAccountType = accountType;

    // pushNamedAndRemoveUntil clears the auth stack — no back button
    // returns here, matching "chosen once, never revisited."
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.home,
      (route) => false,
    );
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
                context,
                icon: FontAwesomeIcons.userTie,
                title: 'I manage groups',
                subtitle: 'You collect contributions and run the payout rotation',
                onTap: () => _choose(context, 'admin'),
              ),
              const SizedBox(height: AppTheme.spacing16),
              _roleCard(
                context,
                icon: FontAwesomeIcons.users,
                title: 'I\'m in groups',
                subtitle: 'You join circles run by someone else and make contributions',
                onTap: () => _choose(context, 'member'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _roleCard(
    BuildContext context, {
    required FaIconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
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
    );
  }
}