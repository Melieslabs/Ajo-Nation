import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../routes/app_router.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/theme_controller.dart';
import '../../../widgets/animated_entry.dart';
import '../../../widgets/app_bottom_nav.dart';
import '../../../widgets/primary_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // FIX #6: local default_view state for the Profile toggle.
  // Swap this for a real preference (Supabase/shared_prefs) once auth is wired.
  bool _isAdminView = true;

  @override
  Widget build(BuildContext context) {
    // ListenableBuilder rebuilds this whole screen whenever ThemeController
    // fires notifyListeners() (i.e. on toggle). This is necessary because
    // AppTheme.* colors are plain getters, not read through Theme.of(context)
    // — so nothing here is otherwise linked to theme changes at all.
    return ListenableBuilder(
      listenable: ThemeController.instance,
      builder: (context, _) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(0),
            child: AppBar(
              backgroundColor: AppTheme.background,
              elevation: 0,
            ),
          ),
          body: IndexedStack(
            index: _currentIndex,
            children: [
              _buildHomeContent(),
              _buildGroupsContent(),
              _buildWalletContent(),
              _buildNotificationsContent(),
              _buildProfileContent(),
            ],
          ),
          bottomNavigationBar: AppBottomNav(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
          ),
        );
      },
    );
  }

  Widget _buildHomeContent() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppTheme.spacing20,
            AppTheme.spacing20,
            AppTheme.spacing20,
            AppTheme.spacing24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bold title header
              Text(
                'Home',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
              ),
              const SizedBox(height: AppTheme.spacing24),

              // Hero card - Days until payout (deep green, full-bleed)
              AnimatedEntry(
                delay: const Duration(milliseconds: 50),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppTheme.spacing24),
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(AppTheme.radius24),
                    boxShadow: AppTheme.cardShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your payout in',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                      ),
                      const SizedBox(height: AppTheme.spacing12),
                      Text(
                        '5',
                        style:
                            Theme.of(context).textTheme.displaySmall?.copyWith(
                                  fontSize: 56,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  height: 1.0,
                                ),
                      ),
                      const SizedBox(height: AppTheme.spacing8),
                      Text(
                        'days',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white70,
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacing24),

              // Two-column stat row: Contributed / Upcoming
              AnimatedEntry(
                delay: const Duration(milliseconds: 100),
                child: Row(
                  children: [
                    Expanded(
                      child: _statBox(
                        context,
                        // FIX #5: standardized calendar icon (was FontAwesomeIcons.calendar
                        // here vs .calendarDays in Wallet — now consistent everywhere)
                        icon: FontAwesomeIcons.handHoldingDollar,
                        title: 'Contributed',
                        value: '₦320,000',
                        bgColor: AppTheme.pasteGreen,
                        iconColor: AppTheme.primary,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacing12),
                    Expanded(
                      child: _statBox(
                        context,
                        icon: FontAwesomeIcons.calendarDays,
                        title: 'Upcoming',
                        value: '₦50,000',
                        bgColor: AppTheme.pastelOrange,
                        iconColor: AppTheme.warning,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacing24),

              // Your Groups section header
              AnimatedEntry(
                delay: const Duration(milliseconds: 150),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Your Groups',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                    ),
                    GestureDetector(
                      // FIX #1: was an empty callback — now actually switches to
                      // the Groups tab (index 1) using existing screen state.
                      onTap: () => setState(() => _currentIndex = 1),
                      child: Text(
                        'See all',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacing16),

              // Groups list - showing both Managing and Member groups
              AnimatedEntry(
                delay: const Duration(milliseconds: 200),
                child: _buildGroupWithRoleBadge(
                  context,
                  name: 'Ajo Circle',
                  amount: '₦50,000',
                  frequency: 'Weekly',
                  nextPayout: 'Fri, 20 Jul',
                  role: 'Managing',
                  onTap: () => Navigator.of(context)
                      .pushNamed(AppRoutes.adminGroupDetail),
                ),
              ),
              const SizedBox(height: AppTheme.spacing12),

              AnimatedEntry(
                delay: const Duration(milliseconds: 250),
                child: _buildGroupWithRoleBadge(
                  context,
                  name: 'Community Ajo',
                  amount: '₦20,000',
                  frequency: 'Monthly',
                  nextPayout: 'Thu, 25 Jul',
                  role: 'Member',
                  onTap: () =>
                      Navigator.of(context).pushNamed(AppRoutes.groupDetail),
                ),
              ),
              const SizedBox(height: AppTheme.spacing12),

              AnimatedEntry(
                delay: const Duration(milliseconds: 300),
                child: _buildGroupWithRoleBadge(
                  context,
                  name: 'Merry Savings',
                  amount: '₦30,000',
                  frequency: 'Biweekly',
                  nextPayout: 'Mon, 29 Jul',
                  role: 'Managing',
                  onTap: () => Navigator.of(context)
                      .pushNamed(AppRoutes.adminGroupDetail),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Stat box with icon chip and bold number
  Widget _statBox(
    BuildContext context, {
    required FaIconData icon,
    required String title,
    required String value,
    required Color bgColor,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radius20),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(AppTheme.radius12),
            ),
            child: Center(
              child: FaIcon(
                icon,
                size: 18,
                color: iconColor,
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spacing12),
          Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: AppTheme.spacing8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
          ),
        ],
      ),
    );
  }

  /// Group card with role badge
  Widget _buildGroupWithRoleBadge(
    BuildContext context, {
    required String name,
    required String amount,
    required String frequency,
    required String nextPayout,
    required String role,
    required VoidCallback onTap,
  }) {
    final isManaging = role == 'Managing';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radius16),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacing8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacing8,
                          vertical: AppTheme.spacing4,
                        ),
                        decoration: BoxDecoration(
                          color: isManaging
                              ? AppTheme.pasteGreen
                              : AppTheme.background,
                          borderRadius:
                              BorderRadius.circular(AppTheme.radius12),
                        ),
                        child: Text(
                          role,
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: isManaging
                                        ? AppTheme.primary
                                        : AppTheme.textSecondary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacing8),
                  Text(
                    '$amount • $frequency',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                          fontSize: 13,
                        ),
                  ),
                  const SizedBox(height: AppTheme.spacing4),
                  Text(
                    'Payout: $nextPayout',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppTheme.muted,
                          fontSize: 12,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppTheme.spacing12),
            // FIX #4: was Icons.chevron_right (Material) — now FontAwesome to
            // match the icon-set rule applied everywhere else.
            FaIcon(
              FontAwesomeIcons.chevronRight,
              color: AppTheme.textSecondary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupsContent() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppTheme.spacing20,
          AppTheme.spacing20,
          AppTheme.spacing20,
          AppTheme.spacing24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Groups',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
            ),
            const SizedBox(height: AppTheme.spacing24),
            Expanded(
              child: ListView(
                children: [
                  _buildGroupWithRoleBadge(
                    context,
                    name: 'Friend Circle',
                    amount: '₦15,000',
                    frequency: 'Weekly',
                    nextPayout: 'Tue, 16 Jul',
                    role: 'Member',
                    onTap: () =>
                        Navigator.of(context).pushNamed(AppRoutes.groupDetail),
                  ),
                  const SizedBox(height: AppTheme.spacing12),
                  _buildGroupWithRoleBadge(
                    context,
                    name: 'Family Ajo',
                    amount: '₦10,000',
                    frequency: 'Monthly',
                    nextPayout: 'Fri, 2 Aug',
                    role: 'Member',
                    onTap: () =>
                        Navigator.of(context).pushNamed(AppRoutes.groupDetail),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletContent() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppTheme.spacing20,
            AppTheme.spacing20,
            AppTheme.spacing20,
            AppTheme.spacing24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Wallet',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
              ),
              const SizedBox(height: AppTheme.spacing24),

              // Hero card - Total contributed
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppTheme.spacing24),
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(AppTheme.radius24),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total saved this cycle',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                    ),
                    const SizedBox(height: AppTheme.spacing12),
                    Text(
                      '₦320,000',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontSize: 48,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.0,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacing24),

              // Two-column info rows
              Row(
                children: [
                  Expanded(
                    child: _infoCard(
                      context,
                      icon: FontAwesomeIcons.moneyBillWave,
                      label: 'Obligations',
                      value: '₦50,000',
                      bgColor: AppTheme.pastelOrange,
                      iconColor: AppTheme.warning,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacing12),
                  Expanded(
                    child: _infoCard(
                      context,
                      icon: FontAwesomeIcons.calendarDays,
                      label: 'Next payout',
                      value: '20 Jul',
                      bgColor: AppTheme.pastelBlue,
                      // FIX #2: was a raw hardcoded Color(0xFF2196F3), breaking
                      // the "everything through AppTheme" rule. Now uses a
                      // named token — ADD THIS to app_theme.dart if missing:
                      //   static const Color info = Color(0xFF2196F3);
                      iconColor: AppTheme.info,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacing24),

              PrimaryButton(
                label: 'View all groups',
                // FIX #7: was pushing AppRoutes.groupDetail (a SINGLE group's
                // detail screen) for a button labeled "view all". Now correctly
                // switches to the Groups tab, consistent with the "See all" fix.
                onPressed: () => setState(() => _currentIndex = 1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Info card for wallet display
  Widget _infoCard(
    BuildContext context, {
    required FaIconData icon,
    required String label,
    required String value,
    required Color bgColor,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radius20),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(AppTheme.radius12),
            ),
            child: Center(
              child: FaIcon(
                icon,
                size: 18,
                color: iconColor,
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spacing12),
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: AppTheme.spacing8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsContent() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppTheme.spacing20,
          AppTheme.spacing20,
          AppTheme.spacing20,
          AppTheme.spacing24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Alerts',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
            ),
            const SizedBox(height: AppTheme.spacing24),
            Expanded(
              child: ListView(
                children: [
                  _notificationCard(
                    context,
                    icon: FontAwesomeIcons.bell,
                    title: 'Payment reminder',
                    subtitle:
                        'Your contribution for Community Ajo is due tomorrow',
                    read: false,
                  ),
                  const SizedBox(height: AppTheme.spacing12),
                  _notificationCard(
                    context,
                    icon: FontAwesomeIcons.circleCheck,
                    title: 'Payout alert',
                    subtitle: 'A payout was processed for Ajo Circle',
                    read: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Notification card
  Widget _notificationCard(
    BuildContext context, {
    required FaIconData icon,
    required String title,
    required String subtitle,
    required bool read,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radius16),
        boxShadow: AppTheme.cardShadow,
        border: read ? null : Border.all(color: AppTheme.primary, width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: read ? AppTheme.background : AppTheme.pasteGreen,
              borderRadius: BorderRadius.circular(AppTheme.radius12),
            ),
            child: Center(
              child: FaIcon(
                icon,
                size: 18,
                color: read ? AppTheme.textSecondary : AppTheme.primary,
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                ),
                const SizedBox(height: AppTheme.spacing4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppTheme.spacing12),
          // FIX #3: both branches used to resolve to AppTheme.primary, so an
          // unread dot looked identical to a read checkmark — no real signal.
          // Unread now renders in a distinct color (AppTheme.warning).
          FaIcon(
            read ? FontAwesomeIcons.circleCheck : FontAwesomeIcons.circle,
            size: 12,
            color: read ? AppTheme.primary : AppTheme.warning,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppTheme.spacing20,
            AppTheme.spacing20,
            AppTheme.spacing20,
            AppTheme.spacing24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profile',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
              ),
              const SizedBox(height: AppTheme.spacing24),

              // Profile header card
              Container(
                padding: const EdgeInsets.all(AppTheme.spacing20),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(AppTheme.radius20),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        borderRadius: BorderRadius.circular(AppTheme.radius20),
                      ),
                      child: const Center(
                        child: Text(
                          'AM',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacing16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Amina Musa',
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                          ),
                          const SizedBox(height: AppTheme.spacing4),
                          // FIX #6: reflects the live toggle state instead of a
                          // hardcoded 'Admin • Ambassador' string.
                          Text(
                            _isAdminView
                                ? 'Admin view • Ambassador'
                                : 'Member view • Ambassador',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  color: AppTheme.textSecondary,
                                  fontSize: 12,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacing24),

              // Settings section
              Text(
                'Settings',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
              ),
              const SizedBox(height: AppTheme.spacing16),

              _profileMenuItem(
                context,
                icon: FontAwesomeIcons.penToSquare,
                title: 'Edit profile',
                onTap: () {},
              ),
              const SizedBox(height: AppTheme.spacing12),

              // FIX #6: the requested default_view toggle was missing entirely.
              // Local state only for now — wire to a real user preference
              // (Supabase profile row / shared_prefs) once auth/backend lands.
              _profileMenuItem(
                context,
                icon: _isAdminView
                    ? FontAwesomeIcons.userGroup
                    : FontAwesomeIcons.user,
                title: _isAdminView
                    ? 'Switch to Member view'
                    : 'Switch to Admin view',
                onTap: () => setState(() => _isAdminView = !_isAdminView),
              ),
              const SizedBox(height: AppTheme.spacing12),

              _buildThemeToggle(context),
              const SizedBox(height: AppTheme.spacing12),

              _profileMenuItem(
                context,
                icon: FontAwesomeIcons.rightFromBracket,
                title: 'Logout',
                isDestructive: true,
                onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.splash,
                  (route) => false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Dark mode toggle row — same visual shell as _profileMenuItem, but with
  /// a functional Switch instead of a chevron, since this is a direct
  /// action rather than navigation to another screen.
  Widget _buildThemeToggle(BuildContext context) {
    final isDark = ThemeController.instance.isDark;

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radius16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        children: [
          FaIcon(
            isDark ? FontAwesomeIcons.moon : FontAwesomeIcons.sun,
            size: 18,
            color: AppTheme.textPrimary,
          ),
          const SizedBox(width: AppTheme.spacing16),
          Expanded(
            child: Text(
              isDark ? 'Dark mode' : 'Light mode',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
            ),
          ),
          Switch(
            value: isDark,
            activeColor: AppTheme.primary,
            onChanged: (_) {
              // No local setState needed here — ThemeController.toggle()
              // calls notifyListeners(), and the ListenableBuilder wrapping
              // the Scaffold in build() picks that up and rebuilds.
              ThemeController.instance.toggle();
            },
          ),
        ],
      ),
    );
  }

  /// Profile menu item
  Widget _profileMenuItem(
    BuildContext context, {
    required FaIconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final textColor = isDestructive ? AppTheme.danger : AppTheme.textPrimary;
    final bgColor =
        isDestructive ? Color.fromRGBO(220, 38, 38, 0.1) : AppTheme.surface;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppTheme.radius16),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Row(
          children: [
            FaIcon(
              icon,
              size: 18,
              color: textColor,
            ),
            const SizedBox(width: AppTheme.spacing16),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: textColor,
                      fontSize: 15,
                    ),
              ),
            ),
            // FIX #4: was Icons.chevron_right (Material) — now FontAwesome.
            FaIcon(
              FontAwesomeIcons.chevronRight,
              color: AppTheme.textSecondary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}