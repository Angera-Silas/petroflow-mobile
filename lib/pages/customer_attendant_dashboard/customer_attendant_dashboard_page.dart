import 'package:flutter/material.dart';
import './customer_attendant_dashboard_controller.dart';

class CustomerAttendantDashboardPage extends StatefulWidget {
    static const name = "CustomerAttendantDashboardPage";


    const CustomerAttendantDashboardPage({super.key});

    @override
    State<CustomerAttendantDashboardPage> createState() => _CustomerAttendantDashboardPageState();
}

class _CustomerAttendantDashboardPageState extends State<CustomerAttendantDashboardPage> {

    final CustomerAttendantDashboardController _controller = CustomerAttendantDashboardController();

    @override
    void initState() {
      super.initState();
    }

    @override
     Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(),
          body: Column(),
        );
     }
}