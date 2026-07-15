import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _icons = [
    Icons.home_filled,
    Icons.groups_2_outlined,
    Icons.account_balance_wallet_outlined,
    Icons.notifications_outlined,
    Icons.person_outline,
  ];

  static const _activeIcons = [
    Icons.home_filled,
    Icons.groups_2,
    Icons.account_balance_wallet,
    Icons.notifications,
    Icons.person,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacing24,
        vertical: AppTheme.spacing20,
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(35.0),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_icons.length, (index) {
          final selected = index == currentIndex;
          return GestureDetector(
            onTap: () => onTap(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(AppTheme.spacing12),
              decoration: BoxDecoration(
                color: selected ? AppTheme.primarySoft : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                selected ? _activeIcons[index] : _icons[index],
                color: selected ? AppTheme.primary : AppTheme.textSecondary,
                size: 26,
              ),
            ),
          );
        }),
      ),
    );
  }
}