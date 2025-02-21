import 'dart:async';

import 'package:flutter/material.dart';
import 'package:petroflow/utils/dummy_data.dart';

class HomeController extends ChangeNotifier {
  int totalSales = DummyData.totalSales;
  double revenue = DummyData.revenue;
  int totalCustomers = DummyData.totalCustomers;
  List<Map<String, dynamic>> transactions = DummyData.getTransactions();
  List<SalesData> salesChartData = DummyData.getSalesChartData();
  Timer? _timer;

  HomeController() {
    _startAutoRefresh();
  }

  void _startAutoRefresh() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _updateData();
    });
  }

  void _updateData() {
    DummyData.updateDummyData();
    totalSales = DummyData.totalSales;
    revenue = DummyData.revenue;
    totalCustomers = DummyData.totalCustomers;
    transactions = DummyData.getTransactions();
    salesChartData = DummyData.getSalesChartData(); // ✅ Update sales chart

    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
