import 'package:flutter/material.dart';

import '../../../routes/app_router.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/animated_entry.dart';
import '../../../widgets/app_bottom_nav.dart';
import '../../../widgets/fintech_card.dart';
import '../../../widgets/group_card.dart';
import '../../../widgets/primary_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final bool _isAdmin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isAdmin ? 'Admin dashboard' : 'Welcome back',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.notifications),
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
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
  }

  Widget _buildHomeContent() {
    if (_isAdmin) {
      return Padding(
        padding: const EdgeInsets.all(AppTheme.spacing24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick stats',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppTheme.spacing16),
            Row(
              children: [
                Expanded(
                  child: AnimatedEntry(
                    delay: const Duration(milliseconds: 50),
                    child: _statCard('Active groups', '3', isHero: true),
                  ),
                ),
                const SizedBox(width: AppTheme.spacing12),
                Expanded(
                  child: AnimatedEntry(
                    delay: const Duration(milliseconds: 100),
                    child: _statCard('Members', '48'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacing12),
            AnimatedEntry(
              delay: const Duration(milliseconds: 150),
              child: _statCard('Pending payouts', '2'),
            ),
            const SizedBox(height: AppTheme.spacing24),
            Text(
              'Managed groups',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppTheme.spacing12),
            Expanded(
              child: ListView(
                children: [
                  AnimatedEntry(
                    delay: const Duration(milliseconds: 100),
                    child: GroupCard(
                      name: 'Ajo Circle',
                      amount: '₦50,000',
                      frequency: 'Weekly',
                      nextPayout: 'Fri, 20 Jul',
                      position: 'Admin',
                      onTap: () => Navigator.of(
                        context,
                      ).pushNamed(AppRoutes.adminGroupDetail),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing16),
                  AnimatedEntry(
                    delay: const Duration(milliseconds: 150),
                    child: GroupCard(
                      name: 'Merry Savings',
                      amount: '₦30,000',
                      frequency: 'Biweekly',
                      nextPayout: 'Mon, 29 Jul',
                      position: 'Admin',
                      onTap: () => Navigator.of(
                        context,
                      ).pushNamed(AppRoutes.adminGroupDetail),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacing24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upcoming payments',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppTheme.spacing12),
          GroupCard(
            name: 'Community Ajo',
            amount: '₦20,000',
            frequency: 'Monthly',
            nextPayout: 'Thu, 25 Jul',
            position: 'Your turn',
            onTap: () => Navigator.of(context).pushNamed(AppRoutes.groupDetail),
          ),
          const SizedBox(height: AppTheme.spacing16),
          PrimaryButton(
            label: 'Join a group',
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.joinGroup),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupsContent() {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacing24),
      child: ListView(
        children: [
          Text('Groups', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppTheme.spacing16),
          GroupCard(
            name: 'Friend Circle',
            amount: '₦15,000',
            frequency: 'Weekly',
            nextPayout: 'Tue, 16 Jul',
            position: '3rd',
            onTap: () => Navigator.of(context).pushNamed(AppRoutes.groupDetail),
          ),
          GroupCard(
            name: 'Family Ajo',
            amount: '₦10,000',
            frequency: 'Monthly',
            nextPayout: 'Fri, 2 Aug',
            position: '7th',
            onTap: () => Navigator.of(context).pushNamed(AppRoutes.groupDetail),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletContent() {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacing24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Wallet overview',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppTheme.spacing24),
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing24),
            decoration: BoxDecoration(
              color: AppTheme.accent,
              borderRadius: BorderRadius.circular(AppTheme.radius16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total contributed',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppTheme.spacing8),
                Text(
                  '₦320,000',
                  style: Theme.of(
                    context,
                  ).textTheme.displaySmall?.copyWith(color: AppTheme.primary),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacing16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Upcoming obligations'),
            trailing: Text(
              '₦50,000',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Next payout date'),
            trailing: Text(
              '20 Jul',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: AppTheme.spacing16),
          PrimaryButton(
            label: 'View all groups',
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.groupDetail),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsContent() {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacing24),
      child: ListView(
        children: [
          Text(
            'Notifications',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppTheme.spacing16),
          ListTile(
            title: const Text('Payment reminder'),
            subtitle: const Text(
              'Your contribution for Community Ajo is due tomorrow',
            ),
            trailing: Icon(
              Icons.circle,
              color: AppTheme.primary,
              size: 12,
            ),
          ),
          ListTile(
            title: const Text('Payout alert'),
            subtitle: const Text('A payout was processed for Ajo Circle'),
            trailing: Icon(
              Icons.circle,
              color: AppTheme.primary,
              size: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent() {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacing24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Profile', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppTheme.spacing24),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const CircleAvatar(child: Text('AM')),
            title: const Text('Amina Musa'),
            subtitle: const Text('Admin • Ambassador'),
          ),
          const SizedBox(height: AppTheme.spacing16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.edit),
            title: const Text('Edit profile'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () => Navigator.of(
              context,
            ).pushNamedAndRemoveUntil(AppRoutes.splash, (route) => false),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String title, String value, {bool isHero = false}) {
    return FintechCard(
      color: isHero ? AppTheme.primarySoft : AppTheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: AppTheme.spacing12),
            Text(
              value,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontSize: 32,
                    color: AppTheme.textPrimary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
