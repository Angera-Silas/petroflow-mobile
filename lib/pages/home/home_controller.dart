import 'dart:async';
import 'dart:convert'; // Import for JSON encoding

import 'package:flutter/material.dart';
import 'package:petroflow/services/api_service.dart';
import 'package:petroflow/services/db_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends ChangeNotifier {
  String userRole = 'user';
  String employeeNo = '';
  int facilityId = 0;
  int shiftId = 0;
  List<String> sellPoints = [];
  bool isLoading = true;

  final ApiService _apiService = ApiService();
  final AppDatabase _db;
  Timer? _timer;

  HomeController(this._db);

  void fetchInitialData() async {
    await _fetchUserRole();
    await _fetchUserData();
    _startAutoRefresh();
    isLoading = false;
    notifyListeners();
  }

  Future<void> _fetchUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userRole = prefs.getString('authRole') ?? 'user';
    notifyListeners();
  }

  Future<void> _fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('authUser');

    if (email == null || email.isEmpty) {
      print("❌ Error: No email found in shared preferences.");
      return;
    }

    try {
      // ✅ Fetch user details
      final userResponse =
          await _apiService.getData('users/get/username/$email');

      if (userResponse is! Map<String, dynamic>) {
        throw Exception(
            "Invalid user response format: Expected Map<String, dynamic>, got ${userResponse.runtimeType}");
      }

      int userId = userResponse['id'];

      // ✅ Fetch employee details
      final userInfoResponse =
          await _apiService.getData('employees/info/$userId');

      if (userInfoResponse is! Map<String, dynamic>) {
        throw Exception("Invalid user info response format.");
      }

      employeeNo = userInfoResponse['employeeNo']?.toString() ?? '';
      facilityId = userInfoResponse['facilityId'] ?? 0;
      final String username =
          userInfoResponse['firstname'] + " " + userInfoResponse['lastname'] ??
              '';

      //save to shared preferences
      prefs.setString('username', username);

      // ✅ Fetch active shift details
      final shiftResponse =
          await _apiService.getData('shifts/get/active/$employeeNo');

      // ✅ Fetch products from API
      final productsResponse =
          await _apiService.getData('products/get/facility/$facilityId');

      // 🛠 Handle both List and Map cases dynamically
      if (shiftResponse is List) {
        if (shiftResponse.isNotEmpty) {
          // Process first shift in the list
          final shift = shiftResponse.first;
          if (shift is Map<String, dynamic>) {
            shiftId = shift['id'];
            sellPoints = (shift['sellingPoints'] as String?)?.split(', ') ?? [];
          } else {
            print("⚠ Invalid shift format in List: ${shift.runtimeType}");
          }
        } else {
          print("⚠ API returned an empty shift list. No active shift.");
          shiftId = 0;
          sellPoints = [];
        }
      } else if (shiftResponse is Map<String, dynamic>) {
        shiftId = shiftResponse['id'];
        sellPoints =
            (shiftResponse['sellingPoints'] as String?)?.split(', ') ?? [];
      } else {
        throw Exception(
            "Unexpected shiftResponse format: ${shiftResponse.runtimeType}");
      }

      // ✅ Save data locally (Convert Map/List to JSON String)
      await _db.insertData("userInfo", jsonEncode(userInfoResponse),
          "employees/get/info/$userId");

      await _db.insertData(
          "shiftInfo",
          jsonEncode({"shifts": shiftResponse}), // Wrap in a map
          "shifts/get/active/$employeeNo");

      await _db.insertData('products', jsonEncode(productsResponse),
          'products/get/facility/$facilityId');
    } catch (e, stacktrace) {
      print('❌ Error fetching user data: $e');
      print(stacktrace);
    }

    notifyListeners();
  }

  void _startAutoRefresh() {
    _timer = Timer.periodic(const Duration(seconds: 15), (timer) {
      _fetchUserData();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
