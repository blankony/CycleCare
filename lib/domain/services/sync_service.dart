import '../../data/local/database.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/repositories/sync_repository.dart';

class SyncService {
  const SyncService(this.repository);

  final SyncRepository repository;

  Future<SyncResult> synchronize() => repository.synchronize();
}

SyncRepository createSyncRepository(
    {required AppDatabase database, required SupabaseClient client}) =>
    SupabaseSyncRepository(database, client);
