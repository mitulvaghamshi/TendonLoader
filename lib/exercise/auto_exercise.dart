import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_table.dart';
import 'package:tendon_loader/modal/prescription.dart';
import 'package:tendon_loader/utils/extension.dart';

class AutoExercise extends StatelessWidget {
  const AutoExercise({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Prescription _pre = context.model.prescription!;
    return Column(children: <Widget>[
      CustomTable(axis: Axis.vertical, columns: const <DataColumn>[
        DataColumn(label: Text('Prescription', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
        DataColumn(label: Text('Detail', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
      ], rows: <DataRow>[
        DataRow(cells: <DataCell>['Target Load: '.toBigCell, '${_pre.targetLoad} Kg'.toBigCell]),
        DataRow(cells: <DataCell>['Hold Time: '.toBigCell, '${_pre.holdTime} Sec'.toBigCell]),
        DataRow(cells: <DataCell>['Rest Time: '.toBigCell, '${_pre.restTime} Sec'.toBigCell]),
        DataRow(cells: <DataCell>['Sets #: '.toBigCell, '${_pre.sets}'.toBigCell]),
        DataRow(cells: <DataCell>['Reps #: '.toBigCell, '${_pre.reps}'.toBigCell]),
        DataRow(cells: <DataCell>['Set rest time: '.toBigCell, '${_pre.setRest} Sec'.toBigCell]),
      ]),
    ]);
  }
}
