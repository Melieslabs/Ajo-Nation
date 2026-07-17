import 'package:ajo_nation/features/admin/screens/manage_payout_order_screen.dart';
import 'package:flutter/material.dart';

import '../data/mock_data_repository.dart';
import '../features/admin/screens/add_manage_members_screen.dart';
import '../features/admin/screens/admin_group_detail_screen.dart';
import '../features/admin/screens/create_group_screen.dart';
import '../features/admin/screens/payout_confirmation_screen.dart';
import '../features/auth/screens/kyc_setup_screen.dart';
import '../features/auth/screens/onboarding_screen.dart';
import '../features/auth/screens/otp_verification_screen.dart';
import '../features/auth/screens/role_selection_screen.dart';
import '../features/auth/screens/sign_in_screen.dart';
import '../features/auth/screens/sign_up_screen.dart';
import '../features/auth/screens/splash_screen.dart';
import '../features/groups/screens/group_detail_screen.dart';
import '../features/groups/screens/join_group_screen.dart';
import '../features/groups/screens/my_contributions_screen.dart';
import '../features/groups/screens/payment_info_screen.dart';
import '../features/groups/screens/timeline_screen.dart';
import '../features/home/screens/admin_home_screen.dart';
import '../features/home/screens/member_home_screen.dart';
import '../features/notifications/screens/notifications_screen.dart';
import '../features/profile/screens/profile_settings_screen.dart';
import '../features/wallet/screens/wallet_overview_screen.dart';

class AppRoutes {
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const signUp = '/sign-up';
  static const signIn = '/sign-in';
  static const otp = '/otp';
  static const roleSelection = '/role-selection';
  static const kyc = '/kyc';
  static const home = '/home';
  static const groupDetail = '/group-detail';
  static const joinGroup = '/join-group';
  static const paymentInfo = '/payment-info';
  static const myContributions = '/my-contributions';
  static const createGroup = '/create-group';
  static const adminGroupDetail = '/admin-group-detail';
  static const groupTimeline = '/group-timeline';
  static const manageMembers = '/manage-members';
  static const managePayoutOrder = '/manage-payout-order';
  static const payoutConfirmation = '/payout-confirmation';
  static const wallet = '/wallet';
  static const notifications = '/notifications';
  static const profile = '/profile';
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRoutes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case AppRoutes.signUp:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case AppRoutes.signIn:
        return MaterialPageRoute(builder: (_) => const SignInScreen());
      case AppRoutes.otp:
        return MaterialPageRoute(builder: (_) => const OtpVerificationScreen());
      case AppRoutes.roleSelection:
        return MaterialPageRoute(builder: (_) => const RoleSelectionScreen());
      case AppRoutes.kyc:
        return MaterialPageRoute(builder: (_) => const KycSetupScreen());

      case AppRoutes.home:
        final isAdmin =
            MockDataRepository.instance.currentAccountType == 'admin';
        return MaterialPageRoute(
          builder: (_) =>
              isAdmin ? const AdminHomeScreen() : const MemberHomeScreen(),
        );

      case AppRoutes.groupDetail:
        final groupId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => GroupDetailScreen(groupId: groupId),
        );
      case AppRoutes.joinGroup:
        return MaterialPageRoute(builder: (_) => const JoinGroupScreen());
      case AppRoutes.paymentInfo:
        final groupId = settings.arguments as String;

        return MaterialPageRoute(
          builder: (_) => PaymentInfoScreen(
            groupId: groupId,
          ),
        );

      case AppRoutes.managePayoutOrder:
        final groupId = settings.arguments as String;

        return MaterialPageRoute(
          builder: (_) => ManagePayoutOrderScreen(
            groupId: groupId,
          ),
        );
      case AppRoutes.myContributions:
        return MaterialPageRoute(builder: (_) => const MyContributionsScreen());
      case AppRoutes.createGroup:
        return MaterialPageRoute(builder: (_) => const CreateGroupScreen());
      case AppRoutes.adminGroupDetail:
        final groupId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => AdminGroupDetailScreen(groupId: groupId),
        );
      case AppRoutes.groupTimeline:
        final groupId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => TimelineScreen(groupId: groupId),
        );
      case AppRoutes.manageMembers:
        return MaterialPageRoute(
          builder: (_) => const AddManageMembersScreen(),
        );
      case AppRoutes.payoutConfirmation:
        return MaterialPageRoute(
          builder: (_) => const PayoutConfirmationScreen(),
        );
      case AppRoutes.wallet:
        return MaterialPageRoute(builder: (_) => const WalletOverviewScreen());
      case AppRoutes.notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());
      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => const ProfileSettingsScreen());
      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
