import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_table.dart';
import 'package:tendon_loader/modal/chartdata.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/screens/homepage.dart';

@immutable
class DataList extends StatelessWidget {
  const DataList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Export?>(
      valueListenable: clickNotifier,
      builder: (BuildContext context, Export? value, Widget? child) {
        if (value == null) return child!;
        return CustomTable(
          rows: _buildRows(value).toList(),
          columns: const <DataColumn>[
            DataColumn(label: Text('No.')),
            DataColumn(label: Text('TIME'), numeric: true),
            DataColumn(label: Text('LOAD'), numeric: true),
          ],
        );
      },
      child: const Center(child: Text('Nothing to show!')),
    );
  }

  Iterable<DataRow> _buildRows(Export value) sync* {
    final List<ChartData> _list = value.exportData!;
    
    for (int i = 0; i < _list.length; i++) {
      yield DataRow(
        color: i.isOdd ? MaterialStateProperty.all<Color?>(Colors.grey.withOpacity(0.3)) : null,
        cells: <DataCell>[
          DataCell(Text('$i.')),
          DataCell(Text(_list[i].time.toStringAsFixed(1))),
          DataCell(Text(_list[i].load.toStringAsFixed(2))),
        ],
      );
    }
  }
}
