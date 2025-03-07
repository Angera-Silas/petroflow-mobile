import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:petroflow/models/sale_model.dart';
import 'package:petroflow/services/api_service.dart';
import 'package:petroflow/services/db_service.dart';

class EditSalePage extends StatefulWidget {
  final SaleModel sale;
  EditSalePage({required this.sale});

  @override
  _EditSalePageState createState() => _EditSalePageState();
}

class _EditSalePageState extends State<EditSalePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _productNameController;
  late TextEditingController _unitsSoldController;
  late TextEditingController _totalAmountBilledController;
  late TextEditingController _totalAmountPaidController;
  late String _paymentMode;

  final AppDatabase _db = AppDatabase();
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _productNameController =
        TextEditingController(text: widget.sale.product_name);
    _unitsSoldController =
        TextEditingController(text: widget.sale.units_sold.toString());
    _totalAmountBilledController =
        TextEditingController(text: widget.sale.total_amount_billed.toString());
    _totalAmountPaidController =
        TextEditingController(text: widget.sale.total_amount_paid.toString());
    _paymentMode = widget.sale.mode_of_payment;
  }

  void _updateSale() async {
    if (_formKey.currentState!.validate()) {
      SaleModel updatedSale = SaleModel(
        id: widget.sale.id,
        timestamp: widget.sale.timestamp,
        product_name: _productNameController.text,
        units_sold: double.parse(_unitsSoldController.text),
        mode_of_payment: _paymentMode,
        total_amount_billed: double.parse(_totalAmountBilledController.text),
        total_amount_paid: double.parse(_totalAmountPaidController.text),
        synced: false, // Mark as unsynced after edit
      );

      try {
        final response = await _apiService.updateData(
            'sales/update/${updatedSale.id}', updatedSale.toJson());
        if (response['status'] == 'success') {
          updatedSale.synced = true;
        } else {
          await _db.insertUnsyncedData(
              "sales",
              jsonEncode(updatedSale.toJson()),
              'sales/update/${updatedSale.id}',
              "PUT");
        }
      } catch (e) {
        // Handle exception
        await _db.insertUnsyncedData("sales", jsonEncode(updatedSale.toJson()),
            'sales/update/${updatedSale.id}', "PUT");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Sale")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                  controller: _productNameController,
                  decoration: InputDecoration(labelText: "Product Name")),
              TextFormField(
                  controller: _unitsSoldController,
                  decoration: InputDecoration(labelText: "Units Sold")),
              TextFormField(
                  controller: _totalAmountBilledController,
                  decoration:
                      InputDecoration(labelText: "Total Amount Billed")),
              TextFormField(
                  controller: _totalAmountPaidController,
                  decoration: InputDecoration(labelText: "Total Amount Paid")),
              DropdownButtonFormField(
                value: _paymentMode,
                items: ["Cash", "Card", "Mobile Money"]
                    .map((mode) =>
                        DropdownMenuItem(value: mode, child: Text(mode)))
                    .toList(),
                onChanged: (value) =>
                    setState(() => _paymentMode = value.toString()),
                decoration: InputDecoration(labelText: "Payment Mode"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                  onPressed: _updateSale, child: Text("Update Sale")),
            ],
          ),
        ),
      ),
    );
  }
}
