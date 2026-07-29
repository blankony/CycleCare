abstract interface class SecurityService {
  Future<bool> isAvailable();
  Future<bool> authenticate();
  Future<bool> isEnabled();
  Future<void> setEnabled(bool enabled);
}
