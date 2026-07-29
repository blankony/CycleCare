import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

class LockPage extends ConsumerStatefulWidget {
  const LockPage({super.key});

  @override
  ConsumerState<LockPage> createState() => _LockPageState();
}

class _LockPageState extends ConsumerState<LockPage> {
  final _auth = LocalAuthentication();
  String _message = 'Kunci biometrik tidak aktif secara otomatis.';

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('App lock')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.fingerprint, size: 64),
              const SizedBox(height: 16),
              Text(_message, textAlign: TextAlign.center),
              const SizedBox(height: 20),
              FilledButton(
                  onPressed: _authenticate,
                  child: const Text('Uji autentikasi perangkat')),
            ]),
          ),
        ),
      );

  Future<void> _authenticate() async {
    try {
      final supported = await _auth.isDeviceSupported();
      if (!supported) {
        setState(() =>
            _message = 'Perangkat ini tidak mendukung autentikasi biometrik.');
        return;
      }
      final authenticated = await _auth.authenticate(
        localizedReason: 'Autentikasi untuk membuka CycleCare',
        options:
            const AuthenticationOptions(biometricOnly: false, stickyAuth: true),
      );
      setState(() => _message =
          authenticated ? 'Autentikasi berhasil.' : 'Autentikasi dibatalkan.');
    } catch (_) {
      setState(
          () => _message = 'Autentikasi tidak tersedia pada perangkat ini.');
    }
  }
}
