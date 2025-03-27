import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:petroflow/models/sale_model.dart';
import 'package:petroflow/services/api_service.dart';
import 'package:petroflow/services/db_service.dart';

class SalesController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final AppDatabase _db;
  List<SaleModel> _sales = [];
  List<SaleModel> _unsyncedSales = [];
  bool _isOffline = false;
  bool _isLoading = true;
  Timer? _timer;

  List<SaleModel> get sales => _sales;

  List<SaleModel> get unsyncedSales => _unsyncedSales;

  bool get isOffline => _isOffline;

  bool get isLoading => _isLoading;

  late String _employeeNo;
  late int _facilityId;
  late int _orgId;

  SalesController(this._db);

  void fetchInitialData() async {
    await _fetchSalesData();
    _startAutoRefresh();
    await _loadLocalSales();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _fetchSalesData() async {
    try {
      final userInfo = await _db.getUserData();
      _employeeNo = userInfo['employeeNo'];
      _facilityId = userInfo['facilityId'];
      _orgId = userInfo['organizationId'];

      final apiSales = await _apiService.getData(
          'sales/get/organization/$_orgId/facility/$_facilityId/employee/$_employeeNo');

      // Ensure that you handle the data type correctly
      if (apiSales is List) {
        _sales = apiSales
            .map<SaleModel>((item) => SaleModel.fromJson(item))
            .toList();
      } else {
        throw Exception('Expected List but got: ${apiSales.runtimeType}');
      }

      // Save the API sales response as JSON
      await _db.insertData('mySales', jsonEncode(apiSales), 'sales/get');

      _isOffline = false;
    } catch (e) {
      print("❌ API fetch failed: $e, loading local sales...");
      await _fetchMySalesDataLocally();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _fetchMySalesDataLocally() async {
    try {
      final localSales = await _db.getSalesData();

      if (localSales != null && localSales.isNotEmpty) {
        _sales = (localSales as List)
            .map<SaleModel>((item) => SaleModel.fromJson(item))
            .toList();
      } else {
        _sales = []; // Handle empty local sales
      }
    } catch (e) {
      print("❌ Error loading local sales: $e");
      _sales = []; // Avoid null issues
    }
  }

  Future<void> _loadLocalSales() async {
    try {
      final unsyncedData = await _db.getUnsyncedData();
      _unsyncedSales = unsyncedData
          .map<SaleModel>((data) => SaleModel.fromJson(jsonDecode(data.data)))
          .toList();
    } catch (e) {
      print("❌ Error loading unsynced sales: $e");
    }
    _isOffline = true;
    _isLoading = false;
    notifyListeners();
  }

  void _startAutoRefresh() {
    _timer = Timer.periodic(const Duration(seconds: 45), (timer) {
      _fetchSalesData();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
