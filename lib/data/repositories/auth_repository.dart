import 'package:supabase_flutter/supabase_flutter.dart';

enum AuthRegistrationResult { signedIn, confirmationRequired }
enum AuthRestoreStatus { noSession, authenticated, expired }

abstract interface class AuthRepository {
  Stream<AuthState> get authStateChanges;
  User? get currentUser;
  Future<AuthRestoreStatus> restoreSession();
  Future<void> signIn({required String email, required String password});
  Future<AuthRegistrationResult> signUp({
    required String email,
    required String password,
  });
  Future<void> signOut();
}

class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository(this.client);

  final SupabaseClient client;

  @override
  Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;

  @override
  User? get currentUser => client.auth.currentUser;

  @override
  Future<AuthRestoreStatus> restoreSession() async {
    final session = client.auth.currentSession;
    if (session == null || client.auth.currentUser == null) {
      return AuthRestoreStatus.noSession;
    }
    if (!session.isExpired) return AuthRestoreStatus.authenticated;
    try {
      final response = await client.auth.refreshSession();
      return response.session == null
          ? AuthRestoreStatus.expired
          : AuthRestoreStatus.authenticated;
    } on AuthException {
      return AuthRestoreStatus.expired;
    } catch (_) {
      return AuthRestoreStatus.expired;
    }
  }

  @override
  Future<void> signIn({required String email, required String password}) async {
    await client.auth.signInWithPassword(email: email, password: password);
  }

  @override
  Future<AuthRegistrationResult> signUp({
    required String email,
    required String password,
  }) async {
    final response = await client.auth.signUp(email: email, password: password);
    return response.session == null
        ? AuthRegistrationResult.confirmationRequired
        : AuthRegistrationResult.signedIn;
  }

  @override
  Future<void> signOut() => client.auth.signOut();
}
