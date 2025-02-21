import 'package:flutter/material.dart';

class PaginatedTable extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const PaginatedTable({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable(
      header: const Text('Recent Transactions'),
      columns: const [
        DataColumn(label: Text('Customer')),
        DataColumn(label: Text('Amount')),
        DataColumn(label: Text('Status')),
      ],
      source: _DataTableSource(data),
      rowsPerPage: 5,
    );
  }
}

class _DataTableSource extends DataTableSource {
  final List<Map<String, dynamic>> data;

  _DataTableSource(this.data);

  @override
  DataRow getRow(int index) {
    final row = data[index];
    return DataRow(cells: [
      DataCell(Text(row['customer'])),
      DataCell(Text("\$${row['amount']}")),
      DataCell(Text(row['status'],
          style: TextStyle(
              color: row['status'] == "Completed"
                  ? Colors.green
                  : Colors.orange))),
    ]);
  }

  @override
  int get rowCount => data.length;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get selectedRowCount => 0;
}
