import 'package:flutter/material.dart';
import 'package:petroflow/components/buttons/bottom_button.dart';
import 'package:petroflow/components/inputs/custom_dropdown.dart';
import 'package:petroflow/components/inputs/custom_text_form_field.dart';
import 'package:petroflow/constants/my_colors.dart';
import 'package:petroflow/models/incident_model.dart';
import 'package:petroflow/services/api_service.dart';
import 'package:petroflow/services/db_service.dart';

class EditIncidentPage extends StatefulWidget {
  final IncidentModel incident;

  EditIncidentPage({required this.incident});

  @override
  _EditIncidentPageState createState() => _EditIncidentPageState();
}

class _EditIncidentPageState extends State<EditIncidentPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _recieverController;
  late TextEditingController _descriptionController;
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
    _titleController = TextEditingController(text: widget.incident.title);
    _recieverController = TextEditingController(text: widget.incident.reciever);
    _descriptionController =
        TextEditingController(text: widget.incident.description);
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
        _selectedReciever = widget.incident.reciever;
        _recievers = recievers;
      });
    } catch (e) {
      print("Error loading data: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _submitIncident() async {
    if (_formKey.currentState!.validate()) {
      IncidentModel updatedIncident = IncidentModel(
        id: widget.incident.id,
        employeeNo: _employeeNo,
        title: _titleController.text,
        reciever: _selectedReciever ?? '',
        description: _descriptionController.text,
        dateReported: widget.incident.dateReported,
        status: widget.incident.status,
      );

      try {
        await _apiService.postData(
            'incidents/update/${updatedIncident.id}', updatedIncident.toJson());
      } catch (e) {
        await _db.insertUnsyncedData(
            "incidents",
            updatedIncident.toJson() as String,
            'incidents/update/${updatedIncident.id}',
            "PUT");
      }

      _showSuccessDialog(updatedIncident);
    }
  }

  void _closeForm() {
    Navigator.of(context).pop();
  }

  void _showSuccessDialog(IncidentModel incident) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: DynamicColors.popupBackgroundColor(context),
          title: Column(
            children: [
              Text(
                "Incident Saved Successfully!",
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
          content: Column(
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
                children: [
                  Text(
                    "Title: ${incident.title}",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16.0,
                      color: DynamicColors.textColor(context),
                    ),
                  ),
                  Text(
                    "Description: ${incident.description}",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16.0,
                      color: DynamicColors.textColor(context),
                    ),
                  ),
                  Text(
                    "Status: ${incident.status}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: DynamicColors.textColor(context),
                    ),
                  ),
                ],
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
              ),
            ],
          ),
          actions: [
            Container(
              color: Colors.green,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _closeForm();
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
          "Edit Incident Info",
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
                getValue: (reciever) => reciever['value'],
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
                buttonTitle: 'Save',
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
