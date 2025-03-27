import 'package:flutter/material.dart';
import 'package:petroflow/constants/my_colors.dart';

class PaginatedTable extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final List<String> columns;
  final String header;
  final int numberOfRowsPerPage;

  const PaginatedTable(
      {super.key,
      required this.data,
      required this.columns,
      required this.numberOfRowsPerPage,
      required this.header});

  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable(
      header: Text('$header',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: DynamicColors.textColor(context),
          )),
      columns: columns
          .map(
            (col) => DataColumn(
              label: Text(
                col,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: DynamicColors.textColor(context),
                ),
              ),
            ),
          )
          .toList(),
      source: _DataTableSource(data, columns, context),
      rowsPerPage: numberOfRowsPerPage,
    );
  }
}

class _DataTableSource extends DataTableSource {
  final List<Map<String, dynamic>> data;
  final List<String> columns;
  BuildContext context;
  _DataTableSource(this.data, this.columns, this.context);

  @override
  DataRow getRow(int index) {
    final row = data[index];

    return DataRow(
        cells: columns
            .map((col) => DataCell(Text(
                  row[col].toString(),
                  style: TextStyle(
                    fontSize: 14,
                    color: DynamicColors.textColor(context),
                  ),
                )))
            .toList());
  }

  @override
  int get rowCount => data.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
