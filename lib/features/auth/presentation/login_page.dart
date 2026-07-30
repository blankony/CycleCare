import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/providers.dart';
import '../../../data/repositories/auth_repository.dart';

enum _AuthMode { login, register }

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _passwordConfirmation = TextEditingController();
  _AuthMode _mode = _AuthMode.login;
  String? _message;
  bool _messageIsError = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _passwordConfirmation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(authenticationStateProvider);
    final repository = ref.watch(authRepositoryProvider);
    final user = repository?.currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text('Akun cloud')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: repository == null
              ? const Center(
                  child: Text(
                    'Cloud backup belum tersedia. Konfigurasi Supabase melalui dart-define terlebih dahulu.',
                  ),
                )
              : user == null
                  ? _buildAuthForm(context)
                  : _buildSignedIn(context, repository, user.email),
        ),
      ),
    );
  }

  Widget _buildAuthForm(BuildContext context) {
    final isRegistering = _mode == _AuthMode.register;
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          Icon(
            isRegistering ? Icons.person_add_outlined : Icons.cloud_outlined,
            size: 56,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            isRegistering ? 'Buat akun CycleCare' : 'Masuk ke CycleCare',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            isRegistering
                ? 'Daftar dengan email dan password untuk mengaktifkan cloud backup.'
                : 'Gunakan akun yang sudah terdaftar untuk mengakses cloud backup.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SegmentedButton<_AuthMode>(
            segments: const [
              ButtonSegment(value: _AuthMode.login, label: Text('Masuk')),
              ButtonSegment(value: _AuthMode.register, label: Text('Daftar')),
            ],
            selected: {_mode},
            onSelectionChanged:
                _isLoading ? null : (selection) => _changeMode(selection.first),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.email],
            decoration: const InputDecoration(labelText: 'Email'),
            validator: (value) {
              final email = value?.trim() ?? '';
              if (email.isEmpty || !email.contains('@')) {
                return 'Masukkan email yang valid.';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _password,
            obscureText: true,
            textInputAction:
                isRegistering ? TextInputAction.next : TextInputAction.done,
            autofillHints: isRegistering
                ? const [AutofillHints.newPassword]
                : const [AutofillHints.password],
            decoration: const InputDecoration(labelText: 'Password'),
            validator: (value) {
              if ((value ?? '').length < 6) {
                return 'Password minimal 6 karakter.';
              }
              return null;
            },
            onFieldSubmitted: isRegistering ? null : (_) => _submit(),
          ),
          if (isRegistering) ...[
            const SizedBox(height: 12),
            TextFormField(
              controller: _passwordConfirmation,
              obscureText: true,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.newPassword],
              decoration: const InputDecoration(labelText: 'Ulangi password'),
              validator: (value) =>
                  value != _password.text ? 'Password tidak sama.' : null,
              onFieldSubmitted: (_) => _submit(),
            ),
          ],
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _isLoading ? null : _submit,
            child: _isLoading
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(isRegistering ? 'Daftar' : 'Masuk'),
          ),
          if (_message != null) ...[
            const SizedBox(height: 12),
            Text(
              _message!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _messageIsError
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSignedIn(
    BuildContext context,
    AuthRepository repository,
    String? email,
  ) {
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.cloud_done_outlined,
                size: 56,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Sudah masuk',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(email ?? 'Akun Supabase aktif'),
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: _isLoading ? null : () => _signOut(repository),
                child: const Text('Keluar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _changeMode(_AuthMode mode) {
    setState(() {
      _mode = mode;
      _message = null;
      _messageIsError = false;
      _passwordConfirmation.clear();
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final repository = ref.read(authRepositoryProvider);
    if (repository == null) return;
    setState(() {
      _isLoading = true;
      _message = null;
    });
    try {
      if (_mode == _AuthMode.login) {
        await repository.signIn(
          email: _email.text.trim(),
          password: _password.text,
        );
        if (mounted) Navigator.of(context).pop();
        return;
      }

      final result = await repository.signUp(
        email: _email.text.trim(),
        password: _password.text,
      );
      if (!mounted) return;
      if (result == AuthRegistrationResult.signedIn) {
        Navigator.of(context).pop();
        return;
      }
      setState(() {
        _mode = _AuthMode.login;
        _password.clear();
        _passwordConfirmation.clear();
        _message =
            'Pendaftaran berhasil. Periksa email untuk konfirmasi, lalu masuk.';
        _messageIsError = false;
      });
    } on AuthException catch (error) {
      if (mounted) {
        setState(() {
          _message = error.message;
          _messageIsError = true;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _message = 'Proses gagal. Periksa koneksi lalu coba lagi.';
          _messageIsError = true;
        });
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signOut(AuthRepository repository) async {
    setState(() => _isLoading = true);
    try {
      await repository.signOut();
    } on AuthException catch (error) {
      if (mounted) {
        setState(() {
          _message = error.message;
          _messageIsError = true;
        });
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
