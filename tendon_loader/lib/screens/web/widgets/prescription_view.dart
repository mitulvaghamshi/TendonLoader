import 'package:flutter/material.dart';
import 'package:tendon_loader/common/constants.dart';
import 'package:tendon_loader/models/exercise.dart';
import 'package:tendon_loader/models/prescription.dart';

class PrescriptionView extends StatelessWidget {
  const PrescriptionView({
    super.key,
    required this.rows,
    required this.columns,
  });

  factory PrescriptionView.export(Exercise export) {
    return PrescriptionView(columns: const <DataColumn>[
      DataColumn(label: Text('Session')),
      DataColumn(label: Text('Detail')),
    ], rows: _ExPrescriptionView._export(export));
  }

  factory PrescriptionView.prescription(Prescription prescription) {
    return PrescriptionView(columns: const <DataColumn>[
      DataColumn(label: Text('Prescription')),
      DataColumn(label: Text('Value')),
    ], rows: _ExPrescriptionView._prescription(prescription));
  }

  final List<DataRow> rows;
  final List<DataColumn> columns;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: DataTable(
        rows: rows,
        columns: columns,
        dataRowMinHeight: 40,
        headingRowHeight: 40,
        dividerThickness: 2,
        headingTextStyle: Styles.titleStyle,
      ),
    );
  }
}

extension _ExPrescriptionView on PrescriptionView {
  static List<DataRow> _prescription(Prescription prescription) {
    return <DataRow>[
      DataRow(cells: <DataCell>[
        'Target load'.toCell,
        '${prescription.targetLoad} Kg'.toCell,
      ]),
      DataRow(cells: <DataCell>[
        'Sets #'.toCell,
        '${prescription.sets}'.toCell,
      ]),
      DataRow(cells: <DataCell>[
        'Reps #'.toCell,
        '${prescription.reps}'.toCell,
      ]),
      DataRow(cells: <DataCell>[
        'Hold time'.toCell,
        '${prescription.holdTime} Sec'.toCell,
      ]),
      DataRow(cells: <DataCell>[
        'Rest time'.toCell,
        '${prescription.restTime} Sec'.toCell,
      ]),
      DataRow(cells: <DataCell>[
        'Set rest time'.toCell,
        '${prescription.setRest} Sec'.toCell,
      ]),
    ];
  }

  static List<DataRow> _export(Exercise export) {
    return <DataRow>[
      DataRow(cells: <DataCell>[
        'User ID'.toCell,
        export.userId.toString().toCell,
      ]),
      DataRow(cells: <DataCell>[
        'Created on'.toCell,
        export.datetime.toCell,
      ]),
      DataRow(cells: <DataCell>[
        'Type'.toCell,
        'export.type'.toCell,
      ]),
      DataRow(cells: <DataCell>[
        'Data status'.toCell,
        'export.status'.toCell,
      ]),
      DataRow(cells: <DataCell>[
        'Device'.toCell,
        export.progressorId.toCell,
      ]),
      DataRow(cells: <DataCell>[
        'Pain score'.toCell,
        '${export.painScore}'.toCell,
      ]),
      DataRow(cells: <DataCell>[
        'Pain tolerable?'.toCell,
        (export.tolerable).toCell,
      ]),
      if (export.mvcValue != null)
        DataRow(cells: <DataCell>[
          'Max force'.toCell,
          '${export.mvcValue} Kg'.toCell
        ])
      else
        ..._prescription(const Prescription.empty()),
    ];
  }
}

extension on String {
  DataCell get toCell => DataCell(Text(this));
}
