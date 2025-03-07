import 'package:flutter/material.dart';
import 'package:petroflow/models/sale_model.dart';
import 'package:petroflow/services/api_service.dart';
import 'package:petroflow/services/db_service.dart';

class SalesController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final AppDatabase _db = AppDatabase();
  List<SaleModel> _sales = [];
  bool _isOffline = false;
  bool _isLoading = true;

  List<SaleModel> get sales => _sales;

  bool get isOffline => _isOffline;

  bool get isLoading => _isLoading;

  SalesController() {
    _fetchSalesData();
  }

  Future<void> _fetchSalesData() async {
    try {
      final apiSales = await _apiService.getData('sales/get/employeeId');
      _sales =
          apiSales.map<SaleModel>((item) => SaleModel.fromJson(item)).toList();
      _isLoading = false;
    } catch (e) {
      print("API fetch failed: $e, loading local sales...");
      await _loadLocalSales();
    }
    notifyListeners();
  }

  Future<void> _loadLocalSales() async {
    final unsyncedSales = await _db.getUnsyncedData();
    _sales = unsyncedSales
        .map<SaleModel>(
            (data) => SaleModel.fromJson(data as Map<String, dynamic>))
        .toList();
    _isOffline = true;
    _isLoading = false;
    notifyListeners();
  }
}
