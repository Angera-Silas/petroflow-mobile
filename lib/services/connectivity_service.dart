import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:petroflow/services/db_service.dart';
import 'package:petroflow/services/sync_service.dart';
import 'package:workmanager/workmanager.dart';

class ConnectivityService {
  static late SyncService _syncService;

  static void initBackgroundSync(AppDatabase database) {
    _syncService = SyncService(database);

    // Initialize WorkManager
    Workmanager().initialize(callbackDispatcher, isInDebugMode: false);

    // Register periodic sync task (every 15 minutes)
    Workmanager().registerPeriodicTask(
      "unsyncedDataSyncTask",
      "syncUnsyncedData",
      frequency: Duration(minutes: 15),
    );

    // Listen for network changes and trigger sync when online
    Connectivity().onConnectivityChanged.listen((result) {
      if (result != ConnectivityResult.none) {
        print("Internet is back! Syncing data...");
        _syncService.syncData();
      }
    });
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
