import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_table.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/utils/common.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/themes.dart';

@immutable
class SessionInfo extends StatelessWidget {
  const SessionInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Export?>(
      valueListenable: exportClick,
      builder: (_, Export? export, Widget? child) {
        if (export == null) return child!;
        return ExpansionTile(
          maintainState: true,
          subtitle: Text(export.dateTime),
          title: Text(export.userId!, style: ts18w5),
          children: <Widget>[
            CustomTable(columns: const <DataColumn>[
              DataColumn(label: Text('Session', style: ts18w5)),
              DataColumn(label: Text('Detail', style: ts18w5)),
            ], rows: <DataRow>[
              DataRow(
                cells: <DataCell>[export.progressorId!.toCell, ''.toCell],
              ),
              DataRow(cells: <DataCell>[
                'Pain score'.toCell,
                '${export.painScore ?? '---'}'.toCell
              ]),
              DataRow(cells: <DataCell>[
                'Pain tolerable?'.toCell,
                (export.isTolerable ?? '---').toCell
              ]),
              if (export.isMVC)
                DataRow(cells: <DataCell>[
                  'Max force'.toCell,
                  '${export.mvcValue} Kg'.toCell
                ])
            ]),
            if (!export.isMVC) export.prescription!.toTable(),
          ],
        );
      },
      child: const SizedBox(),
    );
  }
}
