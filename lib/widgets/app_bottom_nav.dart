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

  static const _items = [
    _BottomNavItem(label: 'Home', icon: Icons.home),
    _BottomNavItem(label: 'Groups', icon: Icons.people),
    _BottomNavItem(label: 'Wallet', icon: Icons.account_balance_wallet),
    _BottomNavItem(label: 'Alerts', icon: Icons.notifications),
    _BottomNavItem(label: 'Profile', icon: Icons.person),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        boxShadow: AppTheme.cardShadow,
      ),
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_items.length, (index) {
          final item = _items[index];
          final selected = index == currentIndex;
          return GestureDetector(
            onTap: () => onTap(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.all(AppTheme.spacing10),
              decoration: BoxDecoration(
                color: selected ? AppTheme.primarySoft : Colors.transparent,
                borderRadius: BorderRadius.circular(AppTheme.radius24),
              ),
              child: Icon(
                item.icon,
                size: 22,
                color: selected ? AppTheme.primary : AppTheme.textSecondary,
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _BottomNavItem {
  const _BottomNavItem({required this.label, required this.icon});
  final String label;
  final IconData icon;
}
