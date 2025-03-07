import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:petroflow/services/api_service.dart';
import 'package:petroflow/services/db_service.dart';

class SyncService {
  static final AppDatabase _db = AppDatabase();
  static final ApiService _apiService = ApiService();

  static Future<void> syncData() async {
    print("Checking for unsynced data...");

    List<UnsyncedData> unsyncedList = await _db.getUnsyncedData();

    if (unsyncedList.isEmpty) {
      print("No unsynced data found.");
      return;
    }

    // Check if the internet is available before syncing
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      print("No internet connection. Sync postponed.");
      return;
    }

    for (UnsyncedData data in unsyncedList) {
      try {
        var response;
        if (data.method == "POST") {
          response =
              await _apiService.postData(data.endpoint, jsonDecode(data.data));
        } else if (data.method == "PUT") {
          response = await _apiService.updateData(
              data.endpoint, jsonDecode(data.data));
        } else if (data.method == "DELETE") {
          response = await _apiService.deleteData(
              data.endpoint, jsonDecode(data.data));
        }
        if (response is http.Response && response.statusCode == 200 ||
            response.statusCode == 201) {
          print("Synced data (ID: ${data.id}) to ${data.endpoint}");
          await _db.markAsSynced(data.id);
        } else if (response is http.Response && response.statusCode != 200 ||
            response.statusCode != 201) {
          print("Failed to sync (ID: ${data.id}) - ${response.statusCode}");
        }
      } catch (e) {
        print("Sync error (ID: ${data.id}) - $e");
      }
    }
  }
}
