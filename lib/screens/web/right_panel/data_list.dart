import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_table.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/textstyles.dart';

@immutable
class DataList extends StatelessWidget {
  const DataList({Key? key, required this.export}) : super(key: key);

  final Export export;

  @override
  Widget build(BuildContext context) {
    return LimitedBox(
      maxWidth: 250,
      child: Column(children: <Widget>[
        ExpansionTile(
          maintainState: true,
          subtitle: Text(export.dateTime),
          title: Text(export.userId!, style: ts18BFF),
          children: <Widget>[
            ListTile(
              title: Text(export.progressorId!),
              leading: const CustomButton(radius: 25, icon: Icon(Icons.bluetooth)),
            ),
            const Divider(),
            ListTile(
              title: const Text('Pain Score'),
              leading: CustomButton(radius: 25, child: Text(export.painScore?.toString() ?? '---')),
            ),
            const Divider(),
            ListTile(
              title: const Text('Pain Tolerable?'),
              leading: CustomButton(radius: 25, child: Text(export.isTolerable ?? '---', textAlign: TextAlign.center)),
            ),
            const Divider(),
            if (export.isMVC)
              ListTile(
                title: const Text('Max Force (kg)'),
                leading: CustomButton(
                  radius: 25,
                  child: Text(export.mvcValue.toString(), textAlign: TextAlign.center),
                ),
              )
            else
              CustomTable(columns: const <DataColumn>[
                DataColumn(label: Text('Prescription')),
                DataColumn(label: Text('Value')),
              ], rows: <DataRow>[
                DataRow(
                    cells: <DataCell>['Target Load: '.toCell, '${export.prescription!.targetLoad} Kg'.toCell]),
                DataRow(cells: <DataCell>['Hold Time: '.toCell, '${export.prescription!.holdTime} Sec'.toCell]),
                DataRow(cells: <DataCell>['Rest Time: '.toCell, '${export.prescription!.restTime} Sec'.toCell]),
                DataRow(cells: <DataCell>['Sets #: '.toCell, '${export.prescription!.sets}'.toCell]),
                DataRow(cells: <DataCell>['Reps #: '.toCell, '${export.prescription!.reps}'.toCell]),
                DataRow(cells: <DataCell>['Set rest time: '.toCell, '${export.prescription!.setRest} Sec'.toCell])
              ]),
            const Divider(),
          ],
        ),
        Expanded(
          child: CustomTable(
            columns: const <DataColumn>[
              DataColumn(label: Text('No.')),
              DataColumn(label: Text('TIME'), numeric: true),
              DataColumn(label: Text('LOAD'), numeric: true),
            ],
            rows: List<DataRow>.generate(export.exportData!.length, (int index) {
              return DataRow(
                color: index.isOdd ? MaterialStateProperty.all<Color?>(Colors.grey.withOpacity(0.3)) : null,
                cells: <DataCell>[
                  DataCell(Text('${index + 1}.')),
                  DataCell(Text(export.exportData![index].time.toStringAsFixed(1))),
                  DataCell(Text(export.exportData![index].load.toStringAsFixed(2))),
                ],
              );
            }),
          ),
        ),
      ]),
    );
  }
}
