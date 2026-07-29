import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

import 'security_service.dart';

class BiometricSecurityService implements SecurityService {
  BiometricSecurityService(
      {LocalAuthentication? auth, FlutterSecureStorage? storage})
      : _auth = auth ?? LocalAuthentication(),
        _storage = storage ?? const FlutterSecureStorage();

  static const _enabledKey = 'biometric_lock_enabled';
  final LocalAuthentication _auth;
  final FlutterSecureStorage _storage;

  @override
  Future<bool> isAvailable() async {
    try {
      return await _auth.isDeviceSupported() && await _auth.canCheckBiometrics;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Autentikasi untuk melindungi data CycleCare',
        options:
            const AuthenticationOptions(stickyAuth: true, biometricOnly: false),
      );
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> isEnabled() async =>
      (await _storage.read(key: _enabledKey)) == 'true';

  @override
  Future<void> setEnabled(bool enabled) async {
    if (enabled && !await authenticate()) return;
    await _storage.write(key: _enabledKey, value: '$enabled');
  }
}
