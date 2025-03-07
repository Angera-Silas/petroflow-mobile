import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:petroflow/models/sale_model.dart';
import 'package:petroflow/services/api_service.dart';
import 'package:petroflow/services/db_service.dart';

class NewSalePage extends StatefulWidget {
  @override
  _NewSalePageState createState() => _NewSalePageState();
}

class _NewSalePageState extends State<NewSalePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _unitsSoldController = TextEditingController();
  final TextEditingController _totalAmountBilledController =
      TextEditingController();
  final TextEditingController _totalAmountPaidController =
      TextEditingController();
  String _paymentMode = "Cash";

  final AppDatabase _db = AppDatabase();
  final ApiService _apiService = ApiService();

  void _saveSale() async {
    if (_formKey.currentState!.validate()) {
      SaleModel newSale = SaleModel(
        id: DateTime.now().millisecondsSinceEpoch,
        timestamp: DateTime.now(),
        product_name: _productNameController.text,
        units_sold: double.parse(_unitsSoldController.text),
        mode_of_payment: _paymentMode,
        total_amount_billed: double.parse(_totalAmountBilledController.text),
        total_amount_paid: double.parse(_totalAmountPaidController.text),
        synced: false,
      );

      try {
        final response =
            await _apiService.postData('sales/add', newSale.toJson());

        if (response is http.Response && !response.containsValue('id')) {
          await _db.insertUnsyncedData(
              "sales", jsonEncode(newSale.toJson()), 'sales/add', "POST");
        }
      } catch (e) {
        await _db.insertUnsyncedData(
            "sales", jsonEncode(newSale.toJson()), 'sales/add', "POST");
      }

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Sale'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _productNameController,
                decoration: InputDecoration(labelText: 'Product Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _unitsSoldController,
                decoration: InputDecoration(labelText: 'Units Sold'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter units sold';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _totalAmountBilledController,
                decoration: InputDecoration(labelText: 'Total Amount Billed'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter total amount billed';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _totalAmountPaidController,
                decoration: InputDecoration(labelText: 'Total Amount Paid'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter total amount paid';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _paymentMode,
                decoration: InputDecoration(labelText: 'Payment Mode'),
                items: ['Cash', 'Card', 'Online']
                    .map((mode) => DropdownMenuItem(
                          value: mode,
                          child: Text(mode),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _paymentMode = value!;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveSale,
                child: Text('Save Sale'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
