import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_button.dart';
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
                ListTile(
                  title: Text(value.progressorId!),
                  leading: const CustomButton(radius: 25, left: Icon(Icons.bluetooth)),
                ),
                const Divider(),
                ListTile(
                  title: const Text('Pain Score'),
                  leading: CustomButton(radius: 25, right: Text(value.painScore?.toString() ?? '---')),
                ),
                const Divider(),
                ListTile(
                  title: const Text('Pain Tolerable?'),
                  leading:
                      CustomButton(radius: 25, right: Text(value.isTolerable ?? '---', textAlign: TextAlign.center)),
                ),
                const Divider(),
                if (value.isMVC)
                  ListTile(
                    title: const Text('Max Force (kg)'),
                    leading: CustomButton(
                      radius: 25,
                      right: Text(value.mvcValue.toString(), textAlign: TextAlign.center),
                    ),
                  )
                else
                  CustomTable(columns: const <DataColumn>[
                    DataColumn(label: Text('Prescription')),
                    DataColumn(label: Text('Value')),
                  ], rows: <DataRow>[
                    DataRow(cells: <DataCell>['Target Load: '.toCell, '${value.prescription!.targetLoad} Kg'.toCell]),
                    DataRow(cells: <DataCell>['Hold Time: '.toCell, '${value.prescription!.holdTime} Sec'.toCell]),
                    DataRow(cells: <DataCell>['Rest Time: '.toCell, '${value.prescription!.restTime} Sec'.toCell]),
                    DataRow(cells: <DataCell>['Sets #: '.toCell, '${value.prescription!.sets}'.toCell]),
                    DataRow(cells: <DataCell>['Reps #: '.toCell, '${value.prescription!.reps}'.toCell]),
                    DataRow(cells: <DataCell>['Set rest time: '.toCell, '${value.prescription!.setRest} Sec'.toCell])
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
      child: Container(),
    );
  }
}
