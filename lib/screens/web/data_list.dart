import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_table.dart';
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
          columns: const <DataColumn>[
            DataColumn(label: Text('No.')),
            DataColumn(label: Text('TIME'), numeric: true),
            DataColumn(label: Text('LOAD'), numeric: true),
          ],
          rows: List<DataRow>.generate(value.exportData!.length, (int index) {
            return DataRow(
              color: index.isOdd ? MaterialStateProperty.all<Color?>(Colors.grey.withOpacity(0.3)) : null,
              cells: <DataCell>[
                DataCell(Text('${index + 1}.')),
                DataCell(Text(value.exportData![index].time.toStringAsFixed(1))),
                DataCell(Text(value.exportData![index].load.toStringAsFixed(2))),
              ],
            );
          }),
        );
      },
      child: const Center(child: Text('Nothing to show!')),
    );
  }
}
