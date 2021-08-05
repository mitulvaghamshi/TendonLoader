import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_table.dart';
import 'package:tendon_loader/modal/prescription.dart';
import 'package:tendon_loader/utils/extension.dart';

class AutoExercise extends StatelessWidget {
  const AutoExercise({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Prescription _pre = context.model.settingsState!.prescription!;
    return CustomTable(columns: const <DataColumn>[
      DataColumn(label: Text('Prescription', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
      DataColumn(label: Text('Detail', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
    ], rows: <DataRow>[
      DataRow(cells: <DataCell>['Target Load: '.toCell, '${_pre.targetLoad} Kg'.toCell]),
      DataRow(cells: <DataCell>['Hold Time: '.toCell, '${_pre.holdTime} Sec'.toCell]),
      DataRow(cells: <DataCell>['Rest Time: '.toCell, '${_pre.restTime} Sec'.toCell]),
      DataRow(cells: <DataCell>['Sets #: '.toCell, '${_pre.sets}'.toCell]),
      DataRow(cells: <DataCell>['Reps #: '.toCell, '${_pre.reps}'.toCell]),
      DataRow(cells: <DataCell>['Set rest time: '.toCell, '${_pre.setRest} Sec'.toCell]),
    ]);
  }
}
