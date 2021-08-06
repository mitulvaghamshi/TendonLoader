import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_table.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/screens/homepage.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/themes.dart';

@immutable
class SessionInfo extends StatelessWidget {
  const SessionInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Export?>(
      valueListenable: clickNotifier,
      builder: (_, Export? value, Widget? child) {
        if (value == null) return child!;
        return ExpansionTile(
          maintainState: true,
          subtitle: Text(value.dateTime),
          title: Text(value.userId!, style: ts18B),
          children: <Widget>[
            CustomTable(columns: const <DataColumn>[
              DataColumn(label: Text('Prescription', style: ts18B)),
              DataColumn(label: Text('Detail', style: ts18B)),
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
        );
      },
      child: const SizedBox(),
    );
  }
}
