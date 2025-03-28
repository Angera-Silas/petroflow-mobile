import 'package:flutter/material.dart';
import 'package:petroflow/components/buttons/bottom_button.dart';
import 'package:petroflow/components/inputs/custom_dropdown.dart';
import 'package:petroflow/components/inputs/custom_text_form_field.dart';
import 'package:petroflow/constants/my_colors.dart';
import 'package:petroflow/models/incident_model.dart';
import 'package:petroflow/services/api_service.dart';
import 'package:petroflow/services/db_service.dart';

class ReportIncidentPage extends StatefulWidget {
  @override
  _ReportIncidentPageState createState() => _ReportIncidentPageState();
}

class _ReportIncidentPageState extends State<ReportIncidentPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _recieverController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final ApiService _apiService = ApiService();
  final AppDatabase _db = AppDatabase();
  String? _selectedReciever;
  late String _employeeNo;
  List<Map<String, dynamic>> _recievers = [];
  bool _isOffline = false;
  bool _isLoading = true;
  late int _facilityId;
  late int _orgId;
  late String _facilityName;
  late String _username;

  @override
  void initState() {
    super.initState();
    _loadRequiredData();
  }

  void _loadRequiredData() async {
    try {
      final userInfo = await _db.getUserData();
      _employeeNo = userInfo['employeeNo'] ?? '';
      _facilityId = userInfo['facilityId'] ?? 0;
      _orgId = userInfo['organizationId'] ?? 0;
      _facilityName = userInfo['facilityName'] ?? "Unknown Facility";
      _username = userInfo['firstname'] + " " + userInfo['lastname'] ??
          "Customer Attendant";

      final recievers = [
        {
          'value': 'STATION_MANAGER',
          'label': 'Station Manager',
        },
        {
          'value': 'RETAILER',
          'label': 'The Head Office',
        },
        {
          'value': 'SYSTEM_ADMIN',
          'label': 'System Admin',
        },
      ];
      setState(() {
        _selectedReciever = recievers[0]['label'];
      });

      _recievers = recievers;
    } catch (e) {
      // Handle error
      print("Error loading data: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _submitIncident() async {
    if (_formKey.currentState!.validate()) {
      IncidentModel newIncident = IncidentModel(
        employeeNo: _employeeNo,
        title: _titleController.text,
        reciever: _selectedReciever ?? '',
        description: _descriptionController.text,
        dateReported: DateTime.now(),
        status: 'Pending',
      );

      try {
        await _apiService.postData('incidents/add', newIncident.toJson());
      } catch (e) {
        await _db.insertUnsyncedData("incidents",
            newIncident.toJson() as String, 'incidents/add', "POST");
      }

      // Show success message - use alert dialog
      _showSuccessDialog(newIncident);
    }
  }

  void _clearForm() {
    //clear form
    _titleController.clear();
    _descriptionController.clear();
    _recieverController.clear();
    setState(() {
      _selectedReciever = _recievers[0]['label'];
    });
  }

  void _showSuccessDialog(IncidentModel incident) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing without pressing OK
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: DynamicColors.popupBackgroundColor(context),
          title: Column(
            children: [
              Text(
                "Incident Reported Successfully!",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "${_facilityName}",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.green,
                    radius: 30.0,
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 40.0,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Reported By: ${_username}",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          actions: [
            Container(
              color: Colors.green,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the popup
                    _clearForm(); // Reset the form
                  },
                  child: Text(
                    "OK",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          "Report Incident",
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              CustomTextFormField(
                labelText: 'Title',
                controller: _titleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                prefixIcon: Icons.title,
              ),
              SizedBox(height: 16),
              CustomDropdown<Map<String, dynamic>>(
                labelText: 'Escalate To',
                items: _recievers,
                value: _selectedReciever != null
                    ? _recievers.firstWhere(
                        (item) => item['label'] == _selectedReciever)
                    : _recievers.first,
                onChanged: (value) {
                  setState(() {
                    _selectedReciever = value != null ? value['label'] : null;
                  });
                },
                getLabel: (reciever) => reciever['label'],
                getValue: (reciver) => reciver['value'],
              ),
              SizedBox(height: 16),
              CustomTextFormField(
                labelText: 'Description',
                controller: _descriptionController,
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                prefixIcon: Icons.description,
              ),
              SizedBox(height: 20),
              BottomButton(
                buttonTitle: 'Submit',
                onTap: _submitIncident,
                bradius: BorderRadius.circular(30),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
