import 'package:flutter/material.dart';
import 'package:tendon_loader/shared/models/export.dart';
import 'package:tendon_loader/shared/utils/extension.dart';
import 'package:tendon_loader/shared/widgets/table_widget.dart';

@immutable
class SessionInfo extends StatelessWidget {
  const SessionInfo({super.key, required this.export});

  final Export export;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      const SizedBox(height: 10),
      TableWidget(columns: const <DataColumn>[
        DataColumn(
          label: Text(
            'Session',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
        DataColumn(
          label: Text(
            'Detail',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
      ], rows: <DataRow>[
        DataRow(cells: <DataCell>[
          'User ID'.toCell,
          (export.userId!).toCell,
        ]),
        DataRow(cells: <DataCell>[
          'Created on'.toCell,
          (export.dateTime).toCell,
        ]),
        DataRow(cells: <DataCell>[
          'Type'.toCell,
          (export.isMVC ? 'MVC Test' : 'Exercise').toCell,
        ]),
        DataRow(cells: <DataCell>[
          'Data status'.toCell,
          (export.status).toCell,
        ]),
        DataRow(cells: <DataCell>[
          'Device'.toCell,
          export.progressorId!.toCell,
        ]),
        DataRow(cells: <DataCell>[
          'Pain score'.toCell,
          '${export.painScore ?? 'Unknown'}'.toCell
        ]),
        DataRow(cells: <DataCell>[
          'Pain tolerable?'.toCell,
          (export.isTolerable ?? 'Unknown').toCell
        ]),
        if (export.isMVC)
          DataRow(cells: <DataCell>[
            'Max force'.toCell,
            '${export.mvcValue} Kg'.toCell
          ]),
        if (!export.isMVC) ...export.prescription!.detailRows,
      ]),
    ]);
  }
}
