import 'package:petroflow/services/sync_service.dart';
import 'package:workmanager/workmanager.dart';

const syncTask = "syncTask";

class BackgroundSync {
  static void initialize() {
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
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await SyncService.syncData();
    return Future.value(true);
  });
}
