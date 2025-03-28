import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:petroflow/components/buttons/bottom_button.dart';
import 'package:petroflow/components/inputs/custom_dropdown.dart';
import 'package:petroflow/components/inputs/custom_text_form_field.dart';
import 'package:petroflow/constants/my_colors.dart';
import 'package:petroflow/models/sale_model.dart';
import 'package:petroflow/services/api_service.dart';
import 'package:petroflow/services/db_service.dart';

class NewSalePage extends StatefulWidget {
  @override
  _NewSalePageState createState() => _NewSalePageState();
}

class _NewSalePageState extends State<NewSalePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _unitsSoldController = TextEditingController();
  final TextEditingController _totalAmountBilledController =
      TextEditingController();
  final TextEditingController _totalAmountPaidController =
      TextEditingController();
  final TextEditingController _discountController =
      TextEditingController(text: '0');

  String _paymentMode = "Cash";
  String _paymentStatus = "Paid";
  String? _selectedSellPoint;
  String? _selectedProduct;
  List<String> _sellPoints = [];
  List<Map<String, dynamic>> _products = [];
  Timer? _timer;
  bool _isLoading = true; // 🔹 Added loading state

  final AppDatabase _db = AppDatabase();
  final ApiService _apiService = ApiService();

  late String _employeeNo;
  late int _shiftId;
  late int _sellPointId;
  late int _facilityId;
  late String _facilityName;
  late String _username;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    setState(
        () => _isLoading = true); // 🔹 Set loading state before fetching data
    try {
      final userInfo = await _db.getUserData();
      final shiftData = await _db.getShiftData();
      final products = await _db.getProductData();

      if (userInfo.isEmpty || shiftData.isEmpty) {
        print("❌ No user or shift info found.");
        return;
      }

      _facilityId = userInfo['facilityId'] ?? 0;
      _employeeNo = userInfo['employeeNo'] ?? "0000";
      _facilityName = userInfo['facilityName'] ?? "Unknown Facility";
      _username = userInfo['firstname'] + " " + userInfo['lastname'] ??
          "Customer Attendant";

      // ✅ Ensure `shiftData['shifts']` is a list and not empty
      if (shiftData['shifts'] is List && shiftData['shifts'].isNotEmpty) {
        final firstShift = shiftData['shifts'][0];

        if (firstShift is Map && firstShift.containsKey('id')) {
          // Ensure shift ID is always an integer
          _shiftId = (firstShift['id'] is int)
              ? firstShift['id']
              : int.tryParse(firstShift['id'].toString()) ?? -1;

          if (_shiftId == -1) {
            print("⚠ Invalid shift ID format.");
            return;
          }
        } else {
          print("⚠ Shift data is not in expected format.");
          return;
        }
      } else {
        print("⚠ No active shift found.");
        return;
      }

      // ✅ Extract selling points from local DB instead of calling API
      if (shiftData['shifts'] is List && shiftData['shifts'].isNotEmpty) {
        final firstShift = shiftData['shifts'][0];

        if (firstShift is Map && firstShift.containsKey('sellingPoints')) {
          print(
              "🔍 SellingPoints Raw Data (Before Processing): ${firstShift['sellingPoints']}");

          // ✅ Case 1: sellingPoints is a comma-separated string -> Convert to list
          _sellPoints = firstShift['sellingPoints']
              .toString()
              .split(',')
              .map((sp) => sp.trim())
              .toList();

          print("✅ Converted Sell Points (from String): $_sellPoints");
        } else {
          print("⚠ No sellingPoints found in local DB.");
        }
      }

      if (_sellPoints.isNotEmpty) {
        setState(() {
          _selectedSellPoint ??= _sellPoints.first; // Set default value
        });
      }

      /// ✅ Fetch products from API
      final productsResponse =
          await _apiService.getData('products/get/facility/$_facilityId');

      // ✅ Since productsResponse is already a list, just convert it
      if (productsResponse is List) {
        _products = List<Map<String, dynamic>>.from(productsResponse);
      } else {
        print("⚠ Unexpected format for productsResponse.");
      }

      setState(() => _isLoading = false);

      setState(() => _isLoading = false);
    } catch (e, stacktrace) {
      print("❌ Error loading user info: $e");
      print(stacktrace);
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchSellPointId(String sellPointName) async {
    final response =
        await _apiService.getData('sellpoints/get/byname/$sellPointName');
    _sellPointId = response['id'];
  }

  void _showSuccessDialog(SaleModel sale) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing without pressing OK
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: DynamicColors.popupBackgroundColor(context),
          title: Column(
            children: [
              Text(
                "Sale Added Successfully!",
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
                    "Product: ${_selectedProduct ?? 'Unknown'}",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16.0,
                      color: DynamicColors.textColor(context),
                    ),
                  ),
                  Text(
                    "Units Sold: ${sale.unitsSold}",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16.0,
                      color: DynamicColors.textColor(context),
                    ),
                  ),
                  Text(
                    "Amount Billed: ${sale.amountBilled}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: DynamicColors.textColor(context),
                    ),
                  ),
                  Text(
                    "Amount Paid: ${sale.amountPaid}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: DynamicColors.textColor(context),
                    ),
                  ),
                  Text(
                    "Payment Mode: ${sale.paymentMethod}",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16.0,
                      color: DynamicColors.textColor(context),
                    ),
                  ),
                  Text(
                    "Payment Status: ${sale.paymentStatus}",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16.0,
                      color: DynamicColors.textColor(context),
                    ),
                  ),
                  Text(
                    "Sell Point: ${_selectedSellPoint ?? 'Unknown'}",
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
                    "Sale By: ${_username}",
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
          actions: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    color: Colors.green,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 10.0),
                      child: Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the popup
                            _resetForm(); // Reset the form
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
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _resetForm() {
    setState(() {
      _unitsSoldController.clear();
      _totalAmountBilledController.clear();
      _totalAmountPaidController.clear();
      _discountController.text = '0';
      _paymentMode = "Cash";
      _paymentStatus = "Paid";
      _selectedSellPoint = _sellPoints.isNotEmpty ? _sellPoints.first : null;
      _selectedProduct =
          _products.isNotEmpty ? _products.first['id'].toString() : null;
    });
  }

  void _saveSale() async {
    if (_formKey.currentState!.validate()) {
      await _fetchSellPointId(_selectedSellPoint ?? '');

      SaleModel newSale = SaleModel(
        dateTime: DateTime.now(),
        productId: int.tryParse(_selectedProduct ?? '0') ?? 0,
        employeeNo: _employeeNo,
        sellPointId: _sellPointId,
        shiftId: _shiftId,
        unitsSold: double.parse(_unitsSoldController.text),
        amountBilled: double.parse(_totalAmountBilledController.text),
        discount: double.parse(_discountController.text),
        amountPaid: double.parse(_totalAmountPaidController.text),
        paymentMethod: _paymentMode,
        paymentStatus: _paymentStatus,
        balance: 0.0,
        status: "Pending",
        synced: false,
      );

      try {
        final response =
            await _apiService.postData('sales/add', newSale.toJson());

        if (response is http.Response && !response.containsValue('id')) {
          await _db.insertUnsyncedData(
              "sales", newSale.toJson() as String, 'sales/add', "POST");
        }
      } catch (e) {
        await _db.insertUnsyncedData(
            "sales", newSale.toJson() as String, 'sales/add', "POST");
      }

      _showSuccessDialog(newSale);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          "Record New Sale",
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
          ? Center(
              child: CircularProgressIndicator(), // 🔹 Show loading indicator
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    CustomDropdown<Map<String, dynamic>>(
                      labelText: 'Product',
                      value: _selectedProduct != null
                          ? _products.firstWhere((product) =>
                              product['id'].toString() == _selectedProduct)
                          : _products.first,
                      items: _products,
                      getLabel: (product) => product['productName'],
                      getValue: (product) => product['id'].toString(),
                      onChanged: (value) {
                        setState(() {
                          _selectedProduct =
                              value != null ? value['id'].toString() : null;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    CustomTextFormField(
                      labelText: 'Units Sold',
                      prefixIcon: Icons.production_quantity_limits,
                      controller: _unitsSoldController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter units sold';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    CustomTextFormField(
                      labelText: 'Total Amount Billed',
                      prefixIcon: Icons.attach_money,
                      controller: _totalAmountBilledController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter total amount billed';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    CustomTextFormField(
                      labelText: 'Total Amount Paid',
                      prefixIcon: Icons.money,
                      controller: _totalAmountPaidController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter total amount paid';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    CustomTextFormField(
                      labelText: 'Discount',
                      prefixIcon: Icons.discount,
                      controller: _discountController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter discount';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    CustomDropdown<String>(
                      labelText: 'Payment Mode',
                      value: _paymentMode,
                      items: [
                        'Cash',
                        'ATM-Card',
                        'M-pesa',
                        'Bank Transfer',
                        'Cheque'
                      ],
                      getLabel: (mode) => mode,
                      getValue: (mode) => mode,
                      onChanged: (value) {
                        setState(() {
                          _paymentMode = value!;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    CustomDropdown<String>(
                      labelText: 'Payment Status',
                      value: _paymentStatus,
                      items: ['Paid', 'Pending', 'Failed'],
                      getLabel: (status) => status,
                      getValue: (status) => status,
                      onChanged: (value) {
                        setState(() {
                          _paymentStatus = value!;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    CustomDropdown<String>(
                      labelText: 'Sell Point',
                      value: _selectedSellPoint ??
                          (_sellPoints.isNotEmpty ? _sellPoints.first : ''),
                      // Ensures a non-null value
                      items: _sellPoints,
                      getLabel: (point) => point,
                      getValue: (point) => point,
                      onChanged: (value) {
                        setState(() {
                          _selectedSellPoint = value;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            width: double.infinity,
                            child: BottomButton(
                              buttonTitle: 'Save Sale',
                              onTap: _saveSale,
                              bradius: BorderRadius.circular(30),
                            ),
                          ),
                  ],
                ),
              ),
            ),
    );
  }
}
