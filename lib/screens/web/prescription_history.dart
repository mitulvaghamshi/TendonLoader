import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_progress.dart';
import 'package:tendon_loader/custom/custom_table.dart';
import 'package:tendon_loader/modal/prescription.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/themes.dart';

@immutable
class PrescriptionHistory extends StatelessWidget {
  const PrescriptionHistory({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, Prescription>>(
      future: context.model.getPrescriptionHistoryOf(id),
      builder: (_, AsyncSnapshot<Map<String, Prescription>> snapshot) {
        if (!snapshot.hasData) return const CustomProgress();
        return SingleChildScrollView(
          child: Column(
            children: snapshot.data!.entries.map((MapEntry<String, Prescription> e) {
              return ExpansionTile(
                maintainState: true,
                title: Text(e.key),
                children: <Widget>[
                  CustomTable(columns: const <DataColumn>[
                    DataColumn(label: Text('Prescription', style: ts18B)),
                    DataColumn(label: Text('Detail', style: ts18B)),
                  ], rows: <DataRow>[
                    DataRow(cells: <DataCell>['Target load'.toCell, '${e.value.targetLoad} Kg'.toCell]),
                    DataRow(cells: <DataCell>['Sets #'.toCell, '${e.value.sets}'.toCell]),
                    DataRow(cells: <DataCell>['Reps #'.toCell, '${e.value.reps}'.toCell]),
                    DataRow(cells: <DataCell>['Hold time'.toCell, '${e.value.holdTime} Sec'.toCell]),
                    DataRow(cells: <DataCell>['Rest time'.toCell, '${e.value.restTime} Sec'.toCell]),
                    DataRow(cells: <DataCell>['Set rest time'.toCell, '${e.value.setRest} Sec'.toCell]),
                  ]),
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
