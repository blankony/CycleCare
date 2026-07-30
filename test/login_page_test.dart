import 'package:cycle_care/app/providers.dart';
import 'package:cycle_care/data/repositories/auth_repository.dart';
import 'package:cycle_care/features/auth/presentation/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _FakeAuthRepository implements AuthRepository {
  String? registeredEmail;
  String? registeredPassword;
  String? signedInEmail;
  bool signedOut = false;
  User? user;

  @override
  Stream<AuthState> get authStateChanges => const Stream.empty();

  @override
  User? get currentUser => user;

  @override
  Future<AuthRestoreStatus> restoreSession() async => user == null
      ? AuthRestoreStatus.noSession
      : AuthRestoreStatus.authenticated;

  @override
  Future<void> signIn(
      {required String email, required String password}) async {
    signedInEmail = email;
  }

  @override
  Future<void> signOut() async {
    signedOut = true;
    user = null;
  }

  @override
  Future<AuthRegistrationResult> signUp({
    required String email,
    required String password,
  }) async {
    registeredEmail = email;
    registeredPassword = password;
    return AuthRegistrationResult.confirmationRequired;
  }
}

void main() {
  testWidgets('signs in and navigates away from the login route',
      (tester) async {
    final repository = _FakeAuthRepository();
    final router = GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
        GoRoute(
            path: '/dashboard',
            builder: (_, __) => const Scaffold(body: Text('Dashboard'))),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authRepositoryProvider.overrideWithValue(repository)],
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'), 'user@example.com');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'), 'secret123');
    await tester.tap(find.widgetWithText(FilledButton, 'Masuk'));
    await tester.pumpAndSettle();

    expect(repository.signedInEmail, 'user@example.com');
    expect(find.text('Dashboard'), findsOneWidget);
  });

  testWidgets('registers a new account from the auth screen', (tester) async {
    final repository = _FakeAuthRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(repository),
        ],
        child: const MaterialApp(home: LoginPage()),
      ),
    );

    await tester.tap(find.text('Daftar').first);
    await tester.pump();
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'), 'user@example.com');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'), 'secret123');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Ulangi password'), 'secret123');
    await tester.tap(find.widgetWithText(FilledButton, 'Daftar'));
    await tester.pump();

    expect(repository.registeredEmail, 'user@example.com');
    expect(repository.registeredPassword, 'secret123');
    expect(
        find.textContaining('Periksa email untuk konfirmasi'), findsOneWidget);
  });

  testWidgets('logs out an authenticated account', (tester) async {
    final repository = _FakeAuthRepository()
      ..user = const User(
        id: 'user-a',
        appMetadata: {},
        userMetadata: {},
        aud: 'authenticated',
        email: 'user@example.com',
        createdAt: '2026-01-01T00:00:00Z',
      );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(home: LoginPage()),
      ),
    );

    await tester.tap(find.widgetWithText(OutlinedButton, 'Keluar'));
    await tester.pump();

    expect(repository.signedOut, isTrue);
  });
}
