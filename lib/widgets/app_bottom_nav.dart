import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../theme/app_theme.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  final List<_BottomNavItem> _items = const [
    _BottomNavItem(
      label: 'Home',
      icon: FontAwesomeIcons.house,
      activeIcon: FontAwesomeIcons.houseChimney,
    ),
    _BottomNavItem(
      label: 'Groups',
      icon: FontAwesomeIcons.users,
      activeIcon: FontAwesomeIcons.usersLine,
    ),
    _BottomNavItem(
      label: 'Wallet',
      icon: FontAwesomeIcons.wallet,
      activeIcon: FontAwesomeIcons.wallet,
    ),
    _BottomNavItem(
      label: 'Alerts',
      icon: FontAwesomeIcons.bell,
      activeIcon: FontAwesomeIcons.bell,
    ),
    _BottomNavItem(
      label: 'Profile',
      icon: FontAwesomeIcons.user,
      activeIcon: FontAwesomeIcons.userCheck,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        boxShadow: AppTheme.cardShadow,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: AppTheme.spacing12,
        horizontal: AppTheme.spacing8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_items.length, (index) {
          final item = _items[index];
          final selected = index == currentIndex;
          return GestureDetector(
            onTap: () => onTap(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacing12,
                vertical: AppTheme.spacing8,
              ),
              decoration: BoxDecoration(
                color: selected ? AppTheme.primarySoft : Colors.transparent,
                borderRadius: BorderRadius.circular(AppTheme.radius24),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FaIcon(
                    selected ? item.activeIcon : item.icon,
                    size: 18,
                    color: selected ? AppTheme.primary : AppTheme.textSecondary,
                  ),
                  if (selected) ...[
                    const SizedBox(width: AppTheme.spacing8),
                    Text(
                      item.label,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _BottomNavItem {
  const _BottomNavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });

  final String label;
  final FaIconData icon;
  final FaIconData activeIcon;
}