import 'package:flutter/material.dart';
import 'package:petroflow/components/tables/paginated_table.dart';
import 'package:petroflow/models/sale_model.dart';
import 'package:petroflow/pages/sales/sales_controller.dart';
import 'package:provider/provider.dart';

class SalesListPage extends StatefulWidget {
  @override
  _SalesListPageState createState() => _SalesListPageState();
}

class _SalesListPageState extends State<SalesListPage> {
  List<SaleModel> _filteredSales = [];
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _filteredSales = context.read<SalesController>().sales;
  }

  void _filterSales(String query) {
    setState(() {
      _searchQuery = query;
      _filteredSales = context
          .read<SalesController>()
          .sales
          .where((sale) =>
              sale.productName
                  .toString()
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              sale.unitsSold
                  .toString()
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              sale.amountPaid
                  .toString()
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              sale.paymentMethod
                  .toString()
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<SalesController>().isLoading;

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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 1.0),
              child: PaginatedTable(
                data: _filteredSales
                    .map((sale) => {
                          'Product Name': sale.productName,
                          'Units Sold': sale.unitsSold,
                          'Amount Paid': sale.amountPaid,
                          'Payment Method': sale.paymentMethod,
                          'Status': sale.status,
                        })
                    .toList(),
                columns: [
                  'Product Name',
                  'Units Sold',
                  'Amount Paid',
                  'Payment Method',
                  'Status'
                ],
                header: 'Sales Data',
                numberOfRowsPerPage: 6,
              ),
            ),
    );
  }
}
