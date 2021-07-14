import 'package:flutter/material.dart';

class CustomTable extends StatelessWidget {
  const CustomTable({Key? key, required this.rows, required this.columns}) : super(key: key);

  final List<DataRow> rows;
  final List<DataColumn> columns;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      primary: false,
      physics: const AlwaysScrollableScrollPhysics(),
      child: DataTable(
        rows: rows,
        columns: columns,
        dataRowHeight: 40,
        headingRowHeight: 40,
        dataTextStyle: TextStyle(color: Theme.of(context).accentColor),
        headingRowColor: MaterialStateProperty.all<Color>(Theme.of(context).accentColor),
        headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
      ),
    );
  }
}
