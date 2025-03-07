import 'package:flutter/material.dart';
import 'package:petroflow/models/sale_model.dart';
import 'package:petroflow/pages/sales/edit_sale.dart';
import 'package:petroflow/services/api_service.dart';

class SalesListPage extends StatefulWidget {
  @override
  _SalesListPageState createState() => _SalesListPageState();
}

class _SalesListPageState extends State<SalesListPage> {
  final ApiService _apiService = ApiService();
  List<SaleModel> _sales = [];
  List<SaleModel> _filteredSales = [];
  String _searchQuery = "";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSales();
  }

  void _fetchSales() async {
    try {
      final response = await _apiService.getData('sales');
      if (response is List) {
        setState(() {
          _sales = response.map((item) => SaleModel.fromJson(item)).toList();
          _filteredSales = _sales;
          _isLoading = false;
        });
      } else {
        print("Failed to fetch sales data: Unexpected response format");
      }
    } catch (e) {
      print("Error fetching sales data: $e");
    }
  }

  void _filterSales(String query) {
    setState(() {
      _searchQuery = query;
      _filteredSales = _sales
          .where((sale) =>
              sale.product_name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
          ),
          onChanged: _filterSales,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _filteredSales.length,
              itemBuilder: (context, index) {
                var sale = _filteredSales[index];
                return ListTile(
                  title:
                      Text("${sale.product_name} - ${sale.units_sold} units"),
                  subtitle: Text(
                      "Paid: ${sale.total_amount_paid}, Mode: ${sale.mode_of_payment}"),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => EditSalePage(sale: sale)),
                  ),
                );
              },
            ),
    );
  }
}
