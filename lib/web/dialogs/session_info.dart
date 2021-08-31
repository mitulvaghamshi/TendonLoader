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
      valueListenable: exportNotifier,
      builder: (_, Export? export, Widget? child) {
        if (export == null) return child!;
        return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          const SizedBox(height: 10),
          CustomTable(columns: const <DataColumn>[
            DataColumn(label: Text('Session', style: ts18w5)),
            DataColumn(label: Text('Detail', style: ts18w5)),
          ], rows: <DataRow>[
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
      },
      child: const Center(child: Text('It\'s Empty!')),
    );
  }
}
