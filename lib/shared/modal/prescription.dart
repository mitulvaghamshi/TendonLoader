import 'package:flutter/material.dart';
import 'package:tendon_loader/shared/constants.dart';

class Prescription {
  Prescription({this.sets, this.reps, this.holdTime, this.restTime, this.targetLoad});

  Prescription.fromMap(Map<String, dynamic> map) {
    sets = int.tryParse(map[Keys.KEY_SETS].toString()) ?? 0;
    reps = int.tryParse(map[Keys.KEY_REPS].toString()) ?? 0;
    holdTime = int.tryParse(map[Keys.KEY_HOLD_TIME].toString()) ?? 0;
    restTime = int.tryParse(map[Keys.KEY_REST_TIME].toString()) ?? 0;
    lastMVC = double.tryParse(map[Keys.KEY_LAST_MVC].toString()) ?? 0;
    targetLoad = double.tryParse(map[Keys.KEY_TARGET_LOAD].toString()) ?? 0;
  }

  int sets;
  int reps;
  int holdTime;
  int restTime;
  double lastMVC;
  double targetLoad;

  Map<String, String> toMap() {
    return <String, String>{
      Keys.KEY_SETS: sets.toString(),
      Keys.KEY_REPS: reps.toString(),
      Keys.KEY_LAST_MVC: lastMVC.toString(),
      Keys.KEY_HOLD_TIME: holdTime.toString(),
      Keys.KEY_REST_TIME: restTime.toString(),
      Keys.KEY_TARGET_LOAD: targetLoad.toString(),
    };
  }

  DataTable toTable() {
    return DataTable(
      columnSpacing: 20,
      dataRowHeight: 40,
      horizontalMargin: 10,
      headingRowHeight: 40,
      headingRowColor: MaterialStateProperty.all<Color>(Colors.grey.withOpacity(0.3)),
      columns: const <DataColumn>[
        DataColumn(label: Text('Last MVC')),
        DataColumn(label: Text('Target Load')),
        DataColumn(label: Text('Hold Time')),
        DataColumn(label: Text('Rest Time')),
        DataColumn(label: Text('Sets #')),
        DataColumn(label: Text('Reps #')),
      ],
      rows: <DataRow>[
        DataRow(cells: <DataCell>[
          DataCell(Text('$lastMVC')),
          DataCell(Text('$targetLoad')),
          DataCell(Text('$holdTime')),
          DataCell(Text('$restTime')),
          DataCell(Text('$sets')),
          DataCell(Text('$reps')),
        ])
      ],
    );
  }
}
