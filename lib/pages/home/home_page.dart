import 'package:flutter/material.dart';
import 'package:petroflow/components/cards/dashboard_card.dart';
import 'package:petroflow/components/tables/paginated_table.dart';
import 'package:petroflow/pages/home/home_controller.dart';
import 'package:petroflow/pages/sales/sales_page.dart';
import 'package:petroflow/utils/dummy_data.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeController(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // Removes the back button
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // Handle menu button press
            },
          ),
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "PetroFlow Dashboard",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "Streamlining Your Petrol Station Operations!",
                style: TextStyle(fontSize: 14.0),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                // Handle notifications button press
              },
            ),
          ],
        ),
        body: Consumer<HomeController>(
          builder: (context, controller, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cards Grid (Reduced Card Height)
                  GridView.builder(
                    shrinkWrap: true, // ✅ Allow GridView to fit content
                    physics:
                        const NeverScrollableScrollPhysics(), // Prevents internal scrolling
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.1, // ✅ Adjusted to reduce height
                    ),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      final items = [
                        {
                          "title": "Total Sales",
                          "icon": Icons.shopping_cart,
                          "value": controller.totalSales.toString(),
                          "route": const SalesPage(),
                        },
                        {
                          "title": "Revenue",
                          "icon": Icons.attach_money,
                          "value": "\ KES${controller.revenue}",
                        },
                        {
                          "title": "Customers Served",
                          "icon": Icons.people,
                          "value": controller.totalCustomers.toString(),
                        },
                        {
                          "title": "Orders",
                          "icon": Icons.receipt,
                          "value": "234",
                        },
                      ];

                      return DashboardCard(
                        title: items[index]["title"] as String,
                        icon: items[index]["icon"] as IconData,
                        value: items[index]["value"] as String,
                        onTap: () {
                          if (items[index]["route"] != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    items[index]["route"] as Widget,
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Sales Chart
                  Container(
                    height: 220,
                    padding: const EdgeInsets.all(16),
                    child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      title: ChartTitle(text: 'Sales Progress'),
                      series: <CartesianSeries<SalesData, String>>[
                        LineSeries<SalesData, String>(
                          dataSource: controller.salesChartData,
                          xValueMapper: (SalesData sales, _) => sales.day,
                          yValueMapper: (SalesData sales, _) => sales.sales,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Paginated Table
                  PaginatedTable(data: controller.transactions),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
