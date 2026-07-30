import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/repositories/auth_repository.dart';

enum AuthSessionStatus { restoring, unauthenticated, authenticated, expired }

class AuthSessionController extends ChangeNotifier {
  AuthSessionController(this.repository) {
    _subscription = repository.authStateChanges.listen(_handleAuthState);
    restore();
  }

  final AuthRepository repository;
  late final StreamSubscription<AuthState> _subscription;
  AuthSessionStatus status = AuthSessionStatus.restoring;
  User? user;

  bool get isAuthenticated =>
      status == AuthSessionStatus.authenticated && user != null;

  Future<void> restore() async {
    status = AuthSessionStatus.restoring;
    notifyListeners();
    final result = await repository.restoreSession();
    user = repository.currentUser;
    status = switch (result) {
      AuthRestoreStatus.authenticated => AuthSessionStatus.authenticated,
      AuthRestoreStatus.expired => AuthSessionStatus.expired,
      AuthRestoreStatus.noSession => AuthSessionStatus.unauthenticated,
    };
    notifyListeners();
  }

  void _handleAuthState(AuthState state) {
    user = state.session?.user;
    status = user == null
        ? AuthSessionStatus.unauthenticated
        : AuthSessionStatus.authenticated;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
