import 'package:flutter/material.dart';

class SalesCard extends StatelessWidget {
  final double amount;
  final String timestamp;
  final bool synced;

  SalesCard(
      {required this.amount, required this.timestamp, this.synced = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        title: Text("Amount: \$${amount.toStringAsFixed(2)}"),
        subtitle: Text("Timestamp: $timestamp"),
        trailing: synced
            ? Icon(Icons.check, color: Colors.green)
            : Icon(Icons.sync, color: Colors.red),
      ),
    );
  }
}
