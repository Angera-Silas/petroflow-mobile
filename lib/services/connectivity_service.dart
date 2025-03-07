import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:petroflow/services/sync_service.dart';
import 'package:workmanager/workmanager.dart';

class ConnectivityService {
  static void initBackgroundSync() {
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
        SyncService.syncData();
      }
    });
  }
}

// WorkManager background task handler
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await SyncService.syncData();
    return Future.value(true);
  });
}
