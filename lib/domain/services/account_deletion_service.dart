import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/local/database.dart';
import 'notification_service.dart';
import 'security_service.dart';

class AccountDeletionService {
  const AccountDeletionService(
      this.client, this.database, this.notifications, this.security);

  final SupabaseClient client;
  final AppDatabase database;
  final NotificationService notifications;
  final SecurityService security;

  Future<void> deleteAccount() async {
    final user = client.auth.currentUser;
    if (user == null) throw StateError('Tidak ada sesi akun aktif.');
    await client.functions.invoke('delete-account');
    await database.deleteUserLocalData(user.id);
    await notifications.cancelAll();
    await security.setEnabled(false);
    try {
      await client.auth.signOut();
    } catch (_) {}
  }
}
