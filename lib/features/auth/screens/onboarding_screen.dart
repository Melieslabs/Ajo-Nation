import 'package:flutter/material.dart';

import '../../../routes/app_router.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/secondary_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<_OnboardingPage> _pages = [
    _OnboardingPage(
      title: 'Track every contribution',
      description:
          'Stay on top of your group cycle without chasing payments manually.',
      icon: Icons.savings,
    ),
    _OnboardingPage(
      title: 'Resolve payouts fast',
      description:
          'Admins can trigger payouts and keep members informed in one place.',
      icon: Icons.account_balance_wallet,
    ),
    _OnboardingPage(
      title: 'Secure and simple',
      description:
          'From signup to KYC, every step is designed to feel calm and clear.',
      icon: Icons.verified_user,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [TextButton(onPressed: _skip, child: const Text('Skip'))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing24),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: _pages.length,
                itemBuilder: (_, index) => _buildSlide(_pages[index]),
              ),
            ),
            const SizedBox(height: AppTheme.spacing24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? AppTheme.primary
                        : AppTheme.textSecondary,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacing24),
            PrimaryButton(
              label: _currentPage == _pages.length - 1
                  ? 'Create account'
                  : 'Next',
              onPressed: _currentPage == _pages.length - 1
                  ? _continue
                  : _nextPage,
            ),
            const SizedBox(height: AppTheme.spacing12),
            SecondaryButton(label: 'Sign in instead', onPressed: _signIn),
          ],
        ),
      ),
    );
  }

  Widget _buildSlide(_OnboardingPage page) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(AppTheme.spacing24),
          decoration: BoxDecoration(
            color: AppTheme.accent,
            borderRadius: BorderRadius.circular(AppTheme.radius16),
          ),
          child: Icon(page.icon, size: 54, color: AppTheme.primary),
        ),
        const SizedBox(height: AppTheme.spacing24),
        Text(
          page.title,
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppTheme.spacing12),
        Text(
          page.description,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _nextPage() {
    _controller.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _continue() => Navigator.of(context).pushNamed(AppRoutes.signUp);

  void _signIn() => Navigator.of(context).pushNamed(AppRoutes.signIn);

  void _skip() => Navigator.of(context).pushReplacementNamed(AppRoutes.signUp);
}

class _OnboardingPage {
  const _OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;
}
