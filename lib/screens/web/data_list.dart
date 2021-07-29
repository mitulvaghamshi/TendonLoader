import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_table.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/screens/homepage.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/themes.dart';

@immutable
class DataList extends StatelessWidget {
  const DataList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Export?>(
      valueListenable: clickNotifier,
      builder: (BuildContext context, Export? value, Widget? child) {
        if (value == null) return child!;
        return Column(
          children: <Widget>[
            ExpansionTile(
              maintainState: true,
              subtitle: Text(value.dateTime),
              title: Text(value.userId!, style: ts18BFF),
              children: <Widget>[
                CustomTable(columns: const <DataColumn>[
                  DataColumn(label: Text('Session')),
                  DataColumn(label: Text('info')),
                ], rows: <DataRow>[
                  DataRow(cells: <DataCell>[value.progressorId!.toCell, ''.toCell]),
                  DataRow(cells: <DataCell>['Pain score'.toCell, '${value.painScore ?? '---'}'.toCell]),
                  DataRow(cells: <DataCell>['Pain tolerable?'.toCell, (value.isTolerable ?? '---').toCell]),
                  if (value.isMVC)
                    DataRow(cells: <DataCell>['Max force'.toCell, '${value.mvcValue} Kg'.toCell])
                  else ...<DataRow>[
                    DataRow(cells: <DataCell>['Target load'.toCell, '${value.prescription!.targetLoad} Kg'.toCell]),
                    DataRow(cells: <DataCell>['Sets #'.toCell, '${value.prescription!.sets}'.toCell]),
                    DataRow(cells: <DataCell>['Reps #'.toCell, '${value.prescription!.reps}'.toCell]),
                    DataRow(cells: <DataCell>['Hold time'.toCell, '${value.prescription!.holdTime} Sec'.toCell]),
                    DataRow(cells: <DataCell>['Rest time'.toCell, '${value.prescription!.restTime} Sec'.toCell]),
                    DataRow(cells: <DataCell>['Set rest time'.toCell, '${value.prescription!.setRest} Sec'.toCell]),
                  ],
                ]),
              ],
            ),
            Expanded(
              child: CustomTable(
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
              ),
            ),
          ],
        );
      },
      child: const Center(child: Text('Nothing to show.')),
    );
  }
}
