import 'package:flutter/material.dart';
import 'package:petroflow/components/cards/home_card.dart';
import 'package:petroflow/constants/my_colors.dart';
import 'package:petroflow/pages/incidents/report_incident.dart';
import 'package:petroflow/pages/incidents/view_incidents.dart';
import 'package:petroflow/pages/page_under_development.dart'
    show UnderDevelopmentPage;
import 'package:petroflow/pages/requests/create_request.dart';
import 'package:petroflow/pages/requests/view_requests.dart';
import 'package:petroflow/pages/sales/list_sales.dart';
import 'package:petroflow/pages/sales/new_sale.dart';
import 'package:petroflow/pages/sales/sales_page.dart' show SalesPage;
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userRole;
  String? username;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getString('authRole') ?? 'user';
      username = prefs.getString('username') ?? '';
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Define role-based dashboard items
    final Map<String, List<Map<String, dynamic>>> roleBasedItems = {
      'OIL_SPECIALIST': [
        {
          'title': 'Oil Analysis',
          'icon': Icons.science,
          'route': UnderDevelopmentPage(pageTitle: "Oil Analysis")
        },
        {
          'title': 'Inventory Management',
          'icon': Icons.inventory,
          'route': UnderDevelopmentPage(pageTitle: "Inventory Management")
        },
        {
          'title': 'Sales Overview',
          'icon': Icons.pie_chart,
          'route': UnderDevelopmentPage(pageTitle: "Sales Overview")
        },
        {
          'title': 'Customer Feedback',
          'icon': Icons.feedback,
          'route': UnderDevelopmentPage(pageTitle: "Customer Feedback")
        },
        {
          'title': 'Quality Reports',
          'icon': Icons.report,
          'route': UnderDevelopmentPage(pageTitle: "Quality Reports")
        },
      ],
      'DEPARTMENT_MANAGER': [
        {
          'title': 'Team Overview',
          'icon': Icons.group,
          'route': UnderDevelopmentPage(pageTitle: "Team Overview")
        },
        {
          'title': 'Performance Metrics',
          'icon': Icons.bar_chart,
          'route': UnderDevelopmentPage(pageTitle: "Performance Metrics")
        },
      ],
      'SYSTEM_ADMIN': [
        {
          'title': 'User Management',
          'icon': Icons.admin_panel_settings,
          'route': UnderDevelopmentPage(pageTitle: "User Management")
        },
        {
          'title': 'System Logs',
          'icon': Icons.storage,
          'route': UnderDevelopmentPage(pageTitle: "System Logs")
        },
        {
          'title': 'System Settings',
          'icon': Icons.settings,
          'route': UnderDevelopmentPage(pageTitle: "System Settings")
        },
        {
          'title': 'Backup & Restore',
          'icon': Icons.backup,
          'route': UnderDevelopmentPage(pageTitle: "Backup & Restore")
        },
        {
          'title': 'Audit Trail',
          'icon': Icons.history,
          'route': UnderDevelopmentPage(pageTitle: "Audit Trail")
        },
      ],
      'ACCOUNTANT': [
        {
          'title': 'Financial Reports',
          'icon': Icons.account_balance,
          'route': UnderDevelopmentPage(pageTitle: "Financial Reports")
        },
        {
          'title': 'Expense Tracking',
          'icon': Icons.receipt_long,
          'route': UnderDevelopmentPage(pageTitle: "Expense Tracking")
        },
      ],
      'STATION_MANAGER': [
        {
          'title': 'Update Metre Reading',
          'icon': Icons.edit,
          'route': UnderDevelopmentPage(pageTitle: "Update Metre Reading")
        },
        {
          'title': 'Approve Sales',
          'icon': Icons.check_circle,
          'route': UnderDevelopmentPage(pageTitle: "Approve Sales")
        },
        {
          'title': 'Station Overview',
          'icon': Icons.store,
          'route': UnderDevelopmentPage(pageTitle: "Station Overview")
        },
        {
          'title': 'Report Incident',
          'icon': Icons.info_outlined,
          'route': UnderDevelopmentPage(pageTitle: "Report Incident")
        },
        {
          'title': 'Manage Requests',
          'icon': Icons.request_page,
          'route': UnderDevelopmentPage(pageTitle: "Manage Requests")
        },
        {
          'title': 'Inventory Management',
          'icon': Icons.inventory,
          'route': UnderDevelopmentPage(pageTitle: "Inventory Management")
        },
        {
          'title': 'Sales Overview',
          'icon': Icons.pie_chart,
          'route': UnderDevelopmentPage(pageTitle: "Sales Overview")
        },
        {
          'title': 'Sales Tracking',
          'icon': Icons.trending_up,
          'route': UnderDevelopmentPage(pageTitle: "Sales Tracking")
        },
        {
          'title': 'Customer Service',
          'icon': Icons.support,
          'route': UnderDevelopmentPage(pageTitle: "Customer Service")
        },
        {
          'title': 'Customer Feedback',
          'icon': Icons.feedback,
          'route': UnderDevelopmentPage(pageTitle: "Customer Feedback")
        },
        {
          'title': 'Compliance Reports',
          'icon': Icons.verified,
          'route': UnderDevelopmentPage(pageTitle: "Compliance Reports")
        },
      ],
      'QUALITY_MARSHAL': [
        {
          'title': 'Inspection Schedules',
          'icon': Icons.schedule,
          'route': UnderDevelopmentPage(pageTitle: "Inspection Schedules")
        },
        {
          "title": "Manage Products",
          "icon": Icons.store_rounded,
          'route': UnderDevelopmentPage(pageTitle: "Manage Products"),
        },
        {
          "title": "View Reports",
          "icon": Icons.receipt,
          'route': UnderDevelopmentPage(pageTitle: "View Reports"),
        },
        {
          "title": "Manage Inventory",
          "icon": Icons.inventory,
          'route': UnderDevelopmentPage(pageTitle: "Manage Inventory"),
        },
        {
          'title': 'Report Incident',
          'icon': Icons.info_outlined,
          'route': UnderDevelopmentPage(pageTitle: "Report Incident")
        },
        {
          'title': 'Manage Requests',
          'icon': Icons.request_page,
          'route': UnderDevelopmentPage(pageTitle: "Manage Requests")
        },
        {
          'title': 'Compliance Reports',
          'icon': Icons.verified,
          'route': UnderDevelopmentPage(pageTitle: "Compliance Reports")
        },
      ],
      'CUSTOMER_ATTENDANT': [
        {
          'title': 'Add New Sale',
          'icon': Icons.add_shopping_cart,
          'route': NewSalePage()
        },
        {'title': 'View Sales', 'icon': Icons.edit, 'route': SalesListPage()},
        {
          'title': 'My Performance',
          'icon': Icons.list,
          'route': SalesPage(userRole: "CUSTOMER_ATTENDANT")
        },
        // {
        //   'title': 'Request Edit',
        //   'icon': Icons.edit,
        //   'route': SalesPage(userRole: "CUSTOMER_ATTENDANT")
        // },
        // {
        //   'title': 'Flag Sale',
        //   'icon': Icons.edit,
        //   'route': SalesPage(userRole: "CUSTOMER_ATTENDANT")
        // },
        {
          'title': 'Report Incident',
          'icon': Icons.speaker_notes,
          'route': ReportIncidentPage(),
        },

        {
          'title': 'Manage Incidents',
          'icon': Icons.info_outlined,
          'route': ViewIncidentsPage(),
        },

        {
          'title': 'Make Requests',
          'icon': Icons.create,
          'route': CreateRequestPage(),
        },
        {
          'title': 'Manage Requests',
          'icon': Icons.request_page,
          'route': ViewRequestsPage(),
        },

        {
          'title': 'Sales Overview',
          'icon': Icons.pie_chart,
          'route': UnderDevelopmentPage(pageTitle: "Sales Overview")
        },
        // {
        //   'title': 'Sales Tracking',
        //   'icon': Icons.trending_up,
        //   'route': UnderDevelopmentPage(pageTitle: "Sales Tracking")
        // },
        {
          'title': 'Customer Service',
          'icon': Icons.support,
          'route': UnderDevelopmentPage(pageTitle: "Customer Service")
        },
        {
          'title': 'Customer Feedback',
          'icon': Icons.feedback,
          'route': UnderDevelopmentPage(pageTitle: "Customer Feedback")
        },
      ],
      'user': [
        {
          'title': 'General Info',
          'icon': Icons.info,
          'route': UnderDevelopmentPage(pageTitle: "General Info")
        },
      ], // Default items for unspecified roles
    };

    // Get the items for the current user's role
    final List<Map<String, dynamic>> items =
        roleBasedItems[userRole] ?? roleBasedItems['user']!;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes the back button
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
        centerTitle: false,
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  // Welcome Text
                  Text(
                    "Hello ${username ?? ''}, Welcome Back!",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: DynamicColors.textColor(context),
                      fontFamily: 'Pacifico',
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Cards Grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 25,
                      childAspectRatio: 2.0,
                    ),
                    itemCount: items.length,
                    // Dynamic item count
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return HomeCard(
                        title: item['title'] as String,
                        icon: item['icon'] as IconData,
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
                ],
              ),
            ),
    );
  }
}
