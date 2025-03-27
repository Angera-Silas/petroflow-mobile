import 'package:flutter/material.dart';
import 'package:petroflow/constants/my_colors.dart' show DynamicColors;
import 'package:petroflow/pages/home/discover.dart';
import 'package:petroflow/pages/home/home_controller.dart';
import 'package:petroflow/pages/home/home_screen.dart';
import 'package:petroflow/pages/home/user_account.dart';
import 'package:petroflow/pages/sales/sales_page.dart';
import 'package:petroflow/services/db_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final controller = HomeController(AppDatabase());
        controller.fetchInitialData(); // Fetch all necessary data
        return controller;
      },
      child: Consumer<HomeController>(
        builder: (context, homeController, child) {
          if (homeController.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return HomeScreenWithNavigation(userRole: homeController.userRole);
        },
      ),
    );
  }
}

class HomeScreenWithNavigation extends StatefulWidget {
  final String userRole;

  const HomeScreenWithNavigation({super.key, required this.userRole});

  @override
  _HomeScreenWithNavigationState createState() =>
      _HomeScreenWithNavigationState();
}

class _HomeScreenWithNavigationState extends State<HomeScreenWithNavigation> {
  int _selectedIndex = 0;
  late List<Widget> _pages;
  late List<BottomNavigationBarItem> _navItems;

  @override
  void initState() {
    super.initState();
    _initializeNavigation();
  }

  void _initializeNavigation() {
    _pages = [
      const HomeScreen(),
      const DiscoverScreen(),
      const AccountScreen(),
    ];
    _navItems = [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: "Home",
        backgroundColor: Colors.transparent,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.explore),
        label: "Discover",
        backgroundColor: Colors.transparent,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: "Account",
        backgroundColor: Colors.transparent,
      ),
    ];

    if (widget.userRole == 'ACCOUNTANT') {
      _pages.insert(1, SalesPage(userRole: 'ACCOUNTANT'));
      _navItems.insert(
        1,
        const BottomNavigationBarItem(
          icon: Icon(Icons.receipt),
          label: "Reports",
          backgroundColor: Colors.transparent,
        ),
      );
    } else if (widget.userRole == 'SYSTEM_ADMIN') {
      _pages.insert(1, SalesPage(userRole: 'SYSTEM_ADMIN'));
      _navItems.insert(
        1,
        const BottomNavigationBarItem(
            backgroundColor: Colors.transparent,
            icon: Icon(Icons.admin_panel_settings),
            label: "Organization"),
      );
    } else {
      _pages.insert(1, SalesPage(userRole: widget.userRole.toString()));
      _navItems.insert(
        1,
        const BottomNavigationBarItem(
            backgroundColor: Colors.transparent,
            icon: Icon(Icons.shopping_cart),
            label: "Sales"),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        backgroundColor: DynamicColors.bottomNavColor(context),
        items: _navItems,
      ),
    );
  }
}
