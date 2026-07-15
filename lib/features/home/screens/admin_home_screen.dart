import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../routes/app_router.dart';
import '../../../data/mock_data_repository.dart';
import '../../../models/group.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/theme_controller.dart';
import '../../../widgets/animated_entry.dart';
import '../../../widgets/app_bottom_nav.dart';

/// Home shell for account_type = 'admin' only. This screen is reached
/// exclusively via the post-auth router check — there is no in-app path
/// that leads a member account here, and no toggle back to it.
class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        ThemeController.instance,
        MockDataRepository.instance,
      ]),
      builder: (context, _) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(0),
            child: AppBar(backgroundColor: AppTheme.background, elevation: 0),
          ),
          body: IndexedStack(
            index: _currentIndex,
            children: [
              _buildDashboard(),
              _buildGroups(),
              _buildWallet(),
              _buildNotifications(),
              _buildProfile(),
            ],
          ),
          bottomNavigationBar: AppBottomNav(
            currentIndex: _currentIndex,
            onTap: (i) => setState(() => _currentIndex = i),
          ),
        );
      },
    );
  }

  Widget _buildDashboard() {
    final repo = MockDataRepository.instance;
    final managedGroups = repo.managedGroups;
    final totalMembers = managedGroups.fold<int>(0, (sum, g) => sum + g.totalMembers);
    // "Pending payouts" = groups where at least one member has hit eligibility
    // this cycle but hasn't been paid out yet. Simplified for now: count
    // groups where paidCount == totalMembers (cycle fully collected,
    // awaiting a payout trigger).
    final pendingPayouts = managedGroups.where((g) => g.paidCount == g.totalMembers).length;

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppTheme.spacing20, AppTheme.spacing20, AppTheme.spacing20, AppTheme.spacing24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Admin dashboard',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontSize: 34, fontWeight: FontWeight.w900, letterSpacing: -0.5,
                      )),
              const SizedBox(height: AppTheme.spacing24),
              AnimatedEntry(
                delay: const Duration(milliseconds: 50),
                child: Row(
                  children: [
                    Expanded(
                      child: _statBox(
                        icon: FontAwesomeIcons.layerGroup,
                        title: 'Active groups',
                        value: '${managedGroups.length}',
                        bgColor: AppTheme.pasteGreen,
                        iconColor: AppTheme.primary,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacing12),
                    Expanded(
                      child: _statBox(
                        icon: FontAwesomeIcons.users,
                        title: 'Members',
                        value: '$totalMembers',
                        bgColor: AppTheme.pastelBlue,
                        iconColor: AppTheme.info,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacing12),
              AnimatedEntry(
                delay: const Duration(milliseconds: 100),
                child: _statBox(
                  icon: FontAwesomeIcons.clockRotateLeft,
                  title: 'Pending payouts',
                  value: '$pendingPayouts',
                  bgColor: AppTheme.pastelOrange,
                  iconColor: AppTheme.warning,
                  fullWidth: true,
                ),
              ),
              const SizedBox(height: AppTheme.spacing24),
              Text('Managed groups',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700, fontSize: 16,
                      )),
              const SizedBox(height: AppTheme.spacing16),
              if (managedGroups.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing24),
                  child: Center(
                    child: Text('No groups yet — create one to get started',
                        style: TextStyle(color: AppTheme.muted, fontSize: 13)),
                  ),
                )
              else
                for (var i = 0; i < managedGroups.length; i++) ...[
                  AnimatedEntry(
                    delay: Duration(milliseconds: 150 + (i * 50)),
                    child: _groupCardFor(managedGroups[i]),
                  ),
                  const SizedBox(height: AppTheme.spacing12),
                ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGroups() {
    final managedGroups = MockDataRepository.instance.managedGroups;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppTheme.spacing20, AppTheme.spacing20, AppTheme.spacing20, AppTheme.spacing24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Groups',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontSize: 34, fontWeight: FontWeight.w900, letterSpacing: -0.5,
                        )),
                GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed(AppRoutes.createGroup),
                  child: Container(
                    padding: const EdgeInsets.all(AppTheme.spacing12),
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(AppTheme.radius16),
                    ),
                    child: const FaIcon(FontAwesomeIcons.plus, size: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacing24),
            Expanded(
              child: managedGroups.isEmpty
                  ? Center(
                      child: Text('No groups yet — create one to get started',
                          style: TextStyle(color: AppTheme.muted, fontSize: 13)),
                    )
                  : ListView(
                      children: [
                        for (final group in managedGroups) ...[
                          _groupCardFor(group),
                          const SizedBox(height: AppTheme.spacing12),
                        ],
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a group card from a real Group, with a secondary "Timeline"
  /// action alongside the main tap-to-manage action.
  Widget _groupCardFor(Group group) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(AppRoutes.adminGroupDetail, arguments: group.id),
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
                  Text(group.name, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppTheme.textPrimary)),
                  const SizedBox(height: AppTheme.spacing8),
                  Text('₦${group.contributionAmount} • ${group.frequency.label}',
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                  const SizedBox(height: AppTheme.spacing4),
                  Text('${group.paidCount}/${group.totalMembers} paid this cycle',
                      style: TextStyle(color: AppTheme.muted, fontSize: 12)),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.groupTimeline, arguments: group.id),
              child: Container(
                padding: const EdgeInsets.all(AppTheme.spacing8),
                decoration: BoxDecoration(
                  color: AppTheme.pasteGreen,
                  borderRadius: BorderRadius.circular(AppTheme.radius12),
                ),
                child: FaIcon(FontAwesomeIcons.clockRotateLeft, size: 14, color: AppTheme.primary),
              ),
            ),
            const SizedBox(width: AppTheme.spacing8),
            FaIcon(FontAwesomeIcons.chevronRight, color: AppTheme.textSecondary, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildWallet() {
    final totalCollected = MockDataRepository.instance.managedGroups
        .fold<num>(0, (sum, g) => sum + g.collectedThisCycle);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Wallet',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 34, fontWeight: FontWeight.w900, letterSpacing: -0.5,
                    )),
            const SizedBox(height: AppTheme.spacing24),
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
                  Text('Collected this cycle',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: AppTheme.spacing12),
                  Text('₦$totalCollected',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontSize: 48, fontWeight: FontWeight.w900, color: Colors.white, height: 1.0,
                          )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotifications() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Alerts',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 34, fontWeight: FontWeight.w900, letterSpacing: -0.5,
                    )),
            const SizedBox(height: AppTheme.spacing24),
            Expanded(
              child: ListView(
                children: [
                  _notificationCard(
                    icon: FontAwesomeIcons.triangleExclamation,
                    title: 'Late payment',
                    subtitle: 'A member missed their contribution in Ajo Circle',
                    read: false,
                  ),
                  const SizedBox(height: AppTheme.spacing12),
                  _notificationCard(
                    icon: FontAwesomeIcons.circleCheck,
                    title: 'Payout processed',
                    subtitle: 'Payout sent for Merry Savings',
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

  Widget _buildProfile() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacing20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Profile',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontSize: 34, fontWeight: FontWeight.w900, letterSpacing: -0.5,
                      )),
              const SizedBox(height: AppTheme.spacing24),
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
                      width: 56, height: 56,
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        borderRadius: BorderRadius.circular(AppTheme.radius20),
                      ),
                      child: const Center(
                        child: Text('AM', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacing16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Amina Musa',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700, fontSize: 16)),
                          const SizedBox(height: AppTheme.spacing4),
                          // Fixed label — account_type is permanent, no switch exists.
                          Text('Ambassador · Admin account',
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppTheme.textSecondary, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacing24),
              Text('Settings',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, fontSize: 16)),
              const SizedBox(height: AppTheme.spacing16),
              _menuItem(icon: FontAwesomeIcons.penToSquare, title: 'Edit profile', onTap: () {}),
              const SizedBox(height: AppTheme.spacing12),
              _themeToggle(context),
              const SizedBox(height: AppTheme.spacing12),
              _menuItem(
                icon: FontAwesomeIcons.rightFromBracket,
                title: 'Logout',
                isDestructive: true,
                onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.splash, (r) => false),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---- shared local helpers ----

  Widget _statBox({
    required FaIconData icon,
    required String title,
    required String value,
    required Color bgColor,
    required Color iconColor,
    bool fullWidth = false,
  }) {
    return Container(
      width: fullWidth ? double.infinity : null,
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
            width: 40, height: 40,
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(AppTheme.radius12)),
            child: Center(child: FaIcon(icon, size: 18, color: iconColor)),
          ),
          const SizedBox(height: AppTheme.spacing12),
          Text(title, style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.w500)),
          const SizedBox(height: AppTheme.spacing8),
          Text(value, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: AppTheme.textPrimary)),
        ],
      ),
    );
  }

  Widget _notificationCard({
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
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: read ? AppTheme.background : AppTheme.pasteGreen,
              borderRadius: BorderRadius.circular(AppTheme.radius12),
            ),
            child: Center(child: FaIcon(icon, size: 18, color: read ? AppTheme.textSecondary : AppTheme.primary)),
          ),
          const SizedBox(width: AppTheme.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppTheme.textPrimary)),
                const SizedBox(height: AppTheme.spacing4),
                Text(subtitle, style: TextStyle(color: AppTheme.textSecondary, fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuItem({
    required FaIconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final textColor = isDestructive ? AppTheme.danger : AppTheme.textPrimary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        decoration: BoxDecoration(
          color: isDestructive ? const Color.fromRGBO(220, 38, 38, 0.1) : AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radius16),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Row(
          children: [
            FaIcon(icon, size: 18, color: textColor),
            const SizedBox(width: AppTheme.spacing16),
            Expanded(child: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: textColor, fontSize: 15))),
            FaIcon(FontAwesomeIcons.chevronRight, color: AppTheme.textSecondary, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _themeToggle(BuildContext context) {
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
          FaIcon(isDark ? FontAwesomeIcons.moon : FontAwesomeIcons.sun, size: 18, color: AppTheme.textPrimary),
          const SizedBox(width: AppTheme.spacing16),
          Expanded(child: Text(isDark ? 'Dark mode' : 'Light mode', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: AppTheme.textPrimary))),
          Switch(value: isDark, activeColor: AppTheme.primary, onChanged: (_) => ThemeController.instance.toggle()),
        ],
      ),
    );
  }
}