import 'package:flutter/material.dart';
import 'package:petroflow/models/incident_model.dart';
import 'package:petroflow/services/api_service.dart';
import 'package:petroflow/services/db_service.dart';

class ViewIncidentsPage extends StatefulWidget {
  @override
  _ViewIncidentsPageState createState() => _ViewIncidentsPageState();
}

class _ViewIncidentsPageState extends State<ViewIncidentsPage> {
  final ApiService _apiService = ApiService();
  final AppDatabase _db = AppDatabase();
  List<IncidentModel> _incidents = [];
  bool _isLoading = true;
  late String _employeeNo;

  @override
  void initState() {
    super.initState();
    _fetchIncidents();
  }

  Future<void> _fetchIncidents() async {
    try {
      final userInfo = await _db.getUserData();
      _employeeNo = userInfo['employeeNo'] ?? '';
      final response =
          await _apiService.getData('incidents/get/employee/$_employeeNo');
      setState(() {
        _incidents = (response as List)
            .map((incident) => IncidentModel.fromJson(incident))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching incidents: $e");
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
          "Manage Incidents",
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
                  ListView.builder(
                    itemCount: _incidents.length,
                    itemBuilder: (context, index) {
                      final incident = _incidents[index];
                      return ListTile(
                        title: Text(incident.title),
                        subtitle: Text(incident.description),
                        trailing: Text(incident.status),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
