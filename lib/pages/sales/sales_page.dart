import 'package:flutter/material.dart';
import 'package:petroflow/components/cards/dashboard_card.dart'
    show DashboardCard;
import 'package:petroflow/pages/sales/list_sales.dart' show SalesListPage;
import 'package:petroflow/pages/sales/new_sale.dart';
import 'package:petroflow/pages/sales/sales_controller.dart';
import 'package:provider/provider.dart';

class SalesPage extends StatelessWidget {
  final String userRole;

  const SalesPage({super.key, required this.userRole});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes the back button
        title: const Text(
          "Sales Management",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Handle search button press
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notifications button press
            },
          ),
        ],
      ),
      body: Consumer<SalesController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Define role-based sales options using uppercase keys
          final Map<String, List<Map<String, dynamic>>> roleOptions = {
            "STATION_MANAGER": [
              {
                "title": "Approve Sales",
                "icon": Icons.bar_chart,
                "route": SalesListPage()
              },
              {
                "title": "Edit Sale",
                "icon": Icons.bar_chart,
                "route": SalesListPage()
              },
              {
                "title": "Delete Sale",
                "icon": Icons.bar_chart,
                "route": SalesListPage()
              },
              {
                "title": "View Sales",
                "icon": Icons.bar_chart,
                "route": SalesListPage()
              },
              {
                "title": "Manage Staff",
                "icon": Icons.people,
                "route": SalesListPage()
              },
            ],
            "CUSTOMER_ATTENDANT": [
              {
                "title": "Add New Sale",
                "icon": Icons.add_box,
                "route": NewSalePage()
              },
              {
                "title": "View Sales",
                "icon": Icons.edit,
                "route": SalesListPage()
              },
              {
                "title": "My Performance",
                "icon": Icons.list,
                "route": SalesListPage()
              },
              {
                "title": "Request Edit",
                "icon": Icons.edit,
                "route": SalesListPage()
              },
              {
                "title": "Flag Sale",
                "icon": Icons.edit,
                "route": SalesListPage()
              }
            ],
            "DEPARTMENT_MANAGER": [
              {
                "title": "Add New Sale",
                "icon": Icons.add_box,
                "route": NewSalePage()
              },
              {
                "title": "View Sales",
                "icon": Icons.edit,
                "route": SalesListPage()
              },
              {
                "title": "Department Performance",
                "icon": Icons.list,
                "route": SalesListPage()
              },
              {
                "title": "Sales Reports",
                "icon": Icons.analytics,
                "route": SalesListPage()
              },
              {
                "title": "Monitor Performance",
                "icon": Icons.trending_up,
                "route": SalesListPage()
              },
            ],
            "QUALITY_MARSHAL": [
              {
                "title": "Verify Sales",
                "icon": Icons.verified,
                "route": SalesListPage()
              },
              {
                "title": "Quality Checks",
                "icon": Icons.fact_check,
                "route": SalesListPage()
              },
              {
                "title": "Update Stock",
                "icon": Icons.fact_check,
                "route": SalesListPage()
              },
            ],
            "SYSTEM_ADMIN": [
              {
                "title": "All Sales",
                "icon": Icons.business,
                "route": SalesListPage()
              },
              {
                "title": "Organization Sales",
                "icon": Icons.bar_chart,
                "route": SalesListPage()
              },
              {
                "title": "Facility Sales",
                "icon": Icons.bar_chart,
                "route": SalesListPage()
              },
              {
                "title": "Employee Sales",
                "icon": Icons.bar_chart,
                "route": SalesListPage()
              },
              {
                "title": "Manage Sales",
                "icon": Icons.manage_accounts,
                "route": SalesListPage()
              },
            ],
          };

          // Default sales options if the role isn't defined
          final List<Map<String, dynamic>> defaultOptions = [
            {
              "title": "View Sales",
              "icon": Icons.attach_money,
              "route": SalesListPage()
            },
            {
              "title": "Add New Sale",
              "icon": Icons.add_box,
              "route": NewSalePage()
            },
          ];

          // Get the correct options based on role
          final salesOptions = roleOptions[userRole] ?? defaultOptions;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: salesOptions.length,
                  itemBuilder: (context, index) {
                    final item = salesOptions[index];
                    return DashboardCard(
                      title: item["title"] as String,
                      icon: item["icon"] as IconData,
                      iconSize: 35,
                      titleFontSize: 14,
                      valueFontSize: 0,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => item["route"] as Widget),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),
                controller.sales.isEmpty
                    ? const Center(child: Text("No sales data available"))
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.sales.length,
                        itemBuilder: (context, index) {
                          final sale = controller.sales[index];
                          return ListTile(
                            title: Text("Amount: \$${sale.total_amount_paid}"),
                            subtitle: Text("Date: ${sale.timestamp}"),
                            trailing: sale.synced
                                ? const Icon(Icons.check, color: Colors.green)
                                : const Icon(Icons.sync, color: Colors.red),
                          );
                        },
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
