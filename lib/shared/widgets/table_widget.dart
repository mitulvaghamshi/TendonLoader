import 'package:flutter/material.dart';

class TableWidget extends StatelessWidget {
  const TableWidget({
    super.key,
    required this.rows,
    required this.columns,
  });

  final List<DataRow> rows;
  final List<DataColumn> columns;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      primary: false,
      child: DataTable(
        rows: rows,
        columns: columns,
        dataRowHeight: 40,
        headingRowHeight: 40,
        horizontalMargin: 16,
      ),
    );
  }
}
