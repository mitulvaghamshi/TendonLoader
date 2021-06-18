import 'package:flutter/material.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/custom/custom_table.dart';
import 'package:tendon_loader/constants/extension.dart';

class DataView extends StatelessWidget {
  const DataView({Key? key, required this.export}) : super(key: key);

  final Export export;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        LimitedBox(
          maxWidth: 250,
          child: export.isMVC
              ? CustomTable(columns: const <DataColumn>[
                  DataColumn(label: Text('Max Force')),
                  DataColumn(label: Text('Progressor ID')),
                ], rows: <DataRow>[
                  DataRow(cells: <DataCell>[
                    '${export.mvcValue} Kg'.toCell,
                    export.progressorId.toCell,
                  ]),
                ])
              : CustomTable(columns: const <DataColumn>[
                  DataColumn(label: Text('Target Load')),
                  DataColumn(label: Text('Hold Time')),
                  DataColumn(label: Text('Rest Time')),
                  DataColumn(label: Text('Sets #')),
                  DataColumn(label: Text('Reps #')),
                  DataColumn(label: Text('Progressor ID')),
                ], rows: <DataRow>[
                  DataRow(cells: <DataCell>[
                    '${export.prescription!.targetLoad} Kg'.toCell,
                    '${export.prescription!.holdTime} Sec'.toCell,
                    '${export.prescription!.restTime} Sec'.toCell,
                    '${export.prescription!.sets}'.toCell,
                    '${export.prescription!.reps}'.toCell,
                    export.progressorId.toCell,
                  ]),
                ]),
        ),
        Expanded(
          child: CustomTable(
            axis: Axis.vertical,
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
                  DataCell(Text(export.exportData[index].time!.toStringAsFixed(1))),
                  DataCell(Text(export.exportData[index].load!.toStringAsFixed(2))),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}
