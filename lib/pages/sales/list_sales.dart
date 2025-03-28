import 'package:flutter/material.dart';
import 'package:petroflow/components/cards/dashboard_card.dart';
import 'package:petroflow/components/tables/paginated_table.dart';
import 'package:petroflow/models/sale_model.dart';
import 'package:petroflow/pages/sales/sales_controller.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        String userRole =
            snapshot.data!.getString('authRole') ?? 'CUSTOMER_ATTENDANT';
        final Map<String, List<Map<String, dynamic>>> roleOptions = {
          "CUSTOMER_ATTENDANT": [
            {
              "title": "Total Sales",
              "icon": Icons.view_list,
              "value": _filteredSales.length.toString(),
            },
            {
              "title": "Total Amount",
              "icon": Icons.attach_money,
              "value": context
                  .read<SalesController>()
                  .sales
                  .fold(0.0, (sum, sale) => sum + sale.amountPaid)
                  .toString(),
            },
            {
              "title": "Total Units Sold",
              "icon": Icons.list,
              "value": context
                  .read<SalesController>()
                  .sales
                  .fold(0.0, (sum, sale) => sum + sale.unitsSold)
                  .toString(),
            },
          ],
        };

        final List<Map<String, dynamic>> defaultOptions = [
          {
            "title": "Total Sales",
            "icon": Icons.attach_money,
            "value": _filteredSales.length.toString(),
          },
        ];

        final salesOptions = roleOptions[userRole] ?? defaultOptions;

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
              : SingleChildScrollView(
                  padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
                  physics: ScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: salesOptions.length,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1.0,
                          ),
                          itemCount: salesOptions.length,
                          itemBuilder: (context, index) {
                            final item = salesOptions[index];
                            return DashboardCard(
                              title: item["title"] as String,
                              value: item["value"] as String,
                              icon: item["icon"] as IconData,
                              iconSize: 35,
                              titleFontSize: 14,
                              valueFontSize: 12,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          item["route"] as Widget),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 1.0),
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
                    ],
                  ),
                ),
        );
      },
    );
  }
}
