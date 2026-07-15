import 'package:flutter/material.dart';

import '../../../routes/app_router.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/primary_button.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              child: const Icon(
                Icons.savings_outlined,
                size: 64,
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
            const SizedBox(height: AppTheme.spacing32),
            PrimaryButton(
              label: 'Get started',
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.onboarding),
            ),
            const SizedBox(height: AppTheme.spacing12),
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pushReplacementNamed(AppRoutes.home),
              child: const Text('Skip to demo'),
            ),
          ],
        ),
      ),
    );
  }
}
