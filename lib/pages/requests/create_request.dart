import 'package:flutter/material.dart';
import 'package:petroflow/components/buttons/bottom_button.dart';
import 'package:petroflow/components/inputs/custom_text_form_field.dart';
import 'package:petroflow/constants/my_colors.dart';
import 'package:petroflow/models/request_model.dart';
import 'package:petroflow/services/api_service.dart';
import 'package:petroflow/services/db_service.dart';

class CreateRequestPage extends StatefulWidget {
  @override
  _CreateRequestPageState createState() => _CreateRequestPageState();
}

class _CreateRequestPageState extends State<CreateRequestPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final ApiService _apiService = ApiService();
  final AppDatabase _db = AppDatabase();
  late String _employeeNo;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final userInfo = await _db.getUserData();
    setState(() {
      _employeeNo = userInfo['employeeNo'] ?? '';
    });
  }

  void _submitRequest() async {
    if (_formKey.currentState!.validate()) {
      RequestModel newRequest = RequestModel(
        employeeNo: _employeeNo,
        title: _titleController.text,
        description: _descriptionController.text,
        dateRequested: DateTime.now(),
        status: 'Pending',
      );

      try {
        await _apiService.postData('requests/add', newRequest.toJson());
      } catch (e) {
        await _db.insertUnsyncedData(
            "requests", newRequest.toJson() as String, 'requests/add', "POST");
      }

      _showSuccessDialog(newRequest);
    }
  }

  void _showSuccessDialog(RequestModel request) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: DynamicColors.popupBackgroundColor(context),
          title: Column(
            children: [
              Text(
                "Request Submitted Successfully!",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "${_employeeNo}",
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
                    "Title: ${request.title}",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16.0,
                      color: DynamicColors.textColor(context),
                    ),
                  ),
                  Text(
                    "Description: ${request.description}",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16.0,
                      color: DynamicColors.textColor(context),
                    ),
                  ),
                  Text(
                    "Status: ${request.status}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: DynamicColors.textColor(context),
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
                    _resetForm();
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

  void _resetForm() {
    _titleController.clear();
    _descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          "Create Request",
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
                onTap: _submitRequest,
                bradius: BorderRadius.circular(30),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
