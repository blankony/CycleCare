import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/providers.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  String? _message;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final client = ref.watch(supabaseClientProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Login cloud backup')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: client == null
            ? const Center(
                child: Text(
                    'Cloud backup belum tersedia. Konfigurasi Supabase melalui dart-define terlebih dahulu.'))
            : ListView(children: [
                TextField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email')),
                const SizedBox(height: 12),
                TextField(
                    controller: _password,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password')),
                const SizedBox(height: 20),
                FilledButton(onPressed: _login, child: const Text('Masuk')),
                if (_message != null) ...[
                  const SizedBox(height: 12),
                  Text(_message!)
                ],
              ]),
      ),
    );
  }

  Future<void> _login() async {
    final client = ref.read(supabaseClientProvider);
    if (client == null) return;
    try {
      await client.auth.signInWithPassword(
          email: _email.text.trim(), password: _password.text);
      if (mounted) Navigator.of(context).pop();
    } on AuthException catch (error) {
      setState(() => _message = 'Login gagal: ${error.message}');
    } catch (_) {
      setState(() => _message = 'Login gagal. Periksa koneksi dan data login.');
    }
  }
}
