import 'package:petroflow/services/db_service.dart';
import 'package:petroflow/services/sync_service.dart';
import 'package:workmanager/workmanager.dart';

const syncTask = "syncTask";

class BackgroundSync {
  static late SyncService _syncService;

  static void initialize(AppDatabase database) {
    _syncService = SyncService(database);

    // Initialize WorkManager
    Workmanager().initialize(callbackDispatcher, isInDebugMode: false);

    // Schedule periodic sync every 15 minutes
    Workmanager().registerPeriodicTask(
      "sync_data_task",
      syncTask,
      frequency: Duration(minutes: 15),
    );
  }
}

// WorkManager background task handler
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final database = AppDatabase(); // Create database instance
    final syncService = SyncService(database); // Use database in SyncService

    await syncService.syncData(); // Perform sync
    return Future.value(true);
  });
}
