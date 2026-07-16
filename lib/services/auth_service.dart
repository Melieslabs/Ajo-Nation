import 'package:supabase_flutter/supabase_flutter.dart';

/// Wraps Supabase Auth for email+password sign-up/sign-in. Singleton, same
/// pattern as MockDataRepository and ThemeController — consistent with
/// the rest of the app's state-management approach.
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final SupabaseClient _supabase = Supabase.instance.client;

  /// Captured by SignUpScreen right before signUp(), consumed by
  /// completeSignup() at RoleSelectionScreen. Transient — cleared after
  /// use. This exists because the `users` row can't be created until
  /// account_type is known (NOT NULL in schema), which happens several
  /// screens after the name is collected.
  String? pendingFullName;

  /// Creates the Supabase auth account. Requires "Confirm email" to be
  /// OFF in Supabase Dashboard > Authentication > Providers > Email —
  /// otherwise currentUser stays null until the person clicks a
  /// confirmation link, and completeSignup() below would fail.
  Future<void> signUp({required String email, required String password}) async {
    await _supabase.auth.signUp(email: email, password: password);
  }

  Future<void> signIn({required String email, required String password}) async {
    await _supabase.auth.signInWithPassword(email: email, password: password);
  }

  /// Fetches the signed-in user's account_type AND full_name in one query.
  /// Call this after signIn() succeeds, before routing to /home — the
  /// caller applies the result to MockDataRepository (see syncCurrentUser),
  /// which is where the app's actual display name comes from now, instead
  /// of a hardcoded placeholder.
  Future<({String accountType, String fullName})> fetchUserProfile() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw StateError('fetchUserProfile called with no active auth session');
    }

    final row = await _supabase
        .from('users')
        .select('account_type, full_name')
        .eq('id', userId)
        .single();

    return (
      accountType: row['account_type'] as String,
      fullName: row['full_name'] as String,
    );
  }

  /// The ONE place a `users` row gets created, called right after Role
  /// Selection. account_type is permanent from this point on — enforced
  /// both by never exposing a way to change it in the UI, AND by a
  /// database trigger that rejects the update even if something tries
  /// to bypass the app (see auth_rls_policies.sql).
  Future<void> completeSignup({required String accountType}) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw StateError('completeSignup called with no active auth session');
    }

    await _supabase.from('users').insert({
      'id': userId,
      'full_name': pendingFullName ?? 'Unnamed user',
      'account_type': accountType,
    });

    pendingFullName = null; // consumed, no longer needed
  }

  Future<void> signOut() => _supabase.auth.signOut();

  String? get currentUserId => _supabase.auth.currentUser?.id;

  bool get isSignedIn => _supabase.auth.currentUser != null;
}

String friendlyAuthError(Object error) {
  final message = error is AuthException ? error.message : error.toString();
  final lower = message.toLowerCase();

  if (lower.contains('invalid login credentials')) {
    return 'No account found with that email, or the password is incorrect.';
  }
  if (lower.contains('user already registered')) {
    return 'An account with this email already exists — try signing in instead.';
  }
  if (lower.contains('email not confirmed')) {
    return 'Please confirm your email before signing in.';
  }
  if (lower.contains('password should be at least')) {
    return 'Password must be at least 6 characters.';
  }
  if (lower.contains('rate limit')) {
    return 'Too many attempts — please wait a moment and try again.';
  }
  if (lower.contains('network') || lower.contains('socket')) {
    return 'Couldn\'t connect. Check your internet connection and try again.';
  }
  return 'Something went wrong. Please try again.';
}