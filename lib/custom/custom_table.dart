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
        dividerThickness: 0,
        headingRowHeight: 40,
        horizontalMargin: 16,
        headingTextStyle: TextStyle(color: Theme.of(context).primaryColor),
        headingRowColor: MaterialStateProperty.all<Color>(Theme.of(context).accentColor),
      ),
    );
  }
}
