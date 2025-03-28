import 'package:flutter/material.dart';
import 'package:petroflow/models/request_model.dart';
import 'package:petroflow/services/api_service.dart';
import 'package:petroflow/services/db_service.dart';

class ViewRequestsPage extends StatefulWidget {
  @override
  _ViewRequestsPageState createState() => _ViewRequestsPageState();
}

class _ViewRequestsPageState extends State<ViewRequestsPage> {
  final ApiService _apiService = ApiService();
  final AppDatabase _db = AppDatabase();
  List<RequestModel> _requests = [];
  bool _isLoading = true;
  late String _employeeNo;

  @override
  void initState() {
    super.initState();
    _fetchRequests();
  }

  Future<void> _fetchRequests() async {
    try {
      final userInfo = await _db.getUserData();
      _employeeNo = userInfo['employeeNo'] ?? '';

      final response =
          await _apiService.getData('requests/get/employee/$_employeeNo');
      setState(() {
        _requests = (response as List)
            .map((request) => RequestModel.fromJson(request))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching requests: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          "Manage Requests",
          style: TextStyle(fontWeight: FontWeight.bold),
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 30),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _requests.length,
                      itemBuilder: (context, index) {
                        final request = _requests[index];
                        return ListTile(
                          title: Text(request.title),
                          subtitle: Text(request.description),
                          trailing: Text(request.status),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
