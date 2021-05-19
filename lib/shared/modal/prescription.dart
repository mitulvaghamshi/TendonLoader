import 'package:flutter/material.dart';
import 'package:tendon_loader/shared/constants.dart';

class Prescription {
  Prescription({this.sets, this.reps, this.holdTime, this.restTime, this.targetLoad, this.setRestTime = 90});

  Prescription.fromMap(Map<String, dynamic> map) {
    sets = int.tryParse(map[Keys.KEY_SETS].toString());
    reps = int.tryParse(map[Keys.KEY_REPS].toString());
    holdTime = int.tryParse(map[Keys.KEY_HOLD_TIME].toString());
    restTime = int.tryParse(map[Keys.KEY_REST_TIME].toString());
    lastMVC = double.tryParse(map[Keys.KEY_LAST_MVC].toString()) ?? 0;
    targetLoad = double.tryParse(map[Keys.KEY_TARGET_LOAD].toString());
  }

  int sets;
  int reps;
  int holdTime;
  int restTime;
  double lastMVC;
  double targetLoad;

  //
  int setRestTime;
  //

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
