import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_table.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/utils/extension.dart';

@immutable
class DataList extends StatelessWidget {
  const DataList({Key? key, required this.export}) : super(key: key);

  final Export export;

  @override
  Widget build(BuildContext context) {
    return LimitedBox(
      maxWidth: 250,
      child: Column(children: <Widget>[
        ListTile(
          title: Text(export.progressorId),
          leading: const CustomButton(icon: Icon(Icons.bluetooth), radius: 25),
        ),
        const Divider(),
        CustomTable(columns: const <DataColumn>[
          DataColumn(label: Text('Prescription')),
          DataColumn(label: Text('Value')),
        ], rows: <DataRow>[
          if (export.isMVC)
            DataRow(cells: <DataCell>['Max Force: '.toBigCell, '${export.mvcValue} Kg'.toBigCell])
          else ...<DataRow>[
            DataRow(cells: <DataCell>['Target Load: '.toBigCell, '${export.prescription!.targetLoad} Kg'.toBigCell]),
            DataRow(cells: <DataCell>['Hold Time: '.toBigCell, '${export.prescription!.holdTime} Sec'.toBigCell]),
            DataRow(cells: <DataCell>['Rest Time: '.toBigCell, '${export.prescription!.restTime} Sec'.toBigCell]),
            DataRow(cells: <DataCell>['Sets #: '.toBigCell, '${export.prescription!.sets}'.toBigCell]),
            DataRow(cells: <DataCell>['Reps #: '.toBigCell, '${export.prescription!.reps}'.toBigCell]),
            DataRow(cells: <DataCell>['Set rest time: '.toBigCell, '${export.prescription!.setRest} Sec'.toBigCell])
          ],
        ]),
        const Divider(),
        Expanded(
          child: CustomTable(
            columns: const <DataColumn>[
              DataColumn(label: Text('No.')),
              DataColumn(label: Text('TIME'), numeric: true),
              DataColumn(label: Text('LOAD'), numeric: true),
            ],
            rows: List<DataRow>.generate(export.exportData.length, (int index) {
              return DataRow(
                color: index.isOdd ? MaterialStateProperty.all<Color?>(Colors.grey.withOpacity(0.3)) : null,
                cells: <DataCell>[
                  '${index + 1}.'.toCell,
                  DataCell(Text(export.exportData[index].time.toStringAsFixed(1))),
                  DataCell(Text(export.exportData[index].load.toStringAsFixed(2))),
                ],
              );
            }),
          ),
        ),
      ]),
    );
  }
}
