import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/local/database.dart';
import 'notification_service.dart';

class AccountDeletionService {
  const AccountDeletionService(this.client, this.database, this.notifications);

  final SupabaseClient client;
  final AppDatabase database;
  final NotificationService notifications;

  Future<void> deleteAccount() async {
    final user = client.auth.currentUser;
    if (user == null) throw StateError('Tidak ada sesi akun aktif.');
    await client.functions.invoke('delete-account');
    await database.deleteUserLocalData(user.id);
    await notifications.cancelAll();
    await client.auth.signOut();
  }
}
