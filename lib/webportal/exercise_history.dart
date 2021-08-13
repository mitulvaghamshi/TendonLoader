import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_table.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/themes.dart';

@immutable
class ExerciseHistory extends StatelessWidget {
  const ExerciseHistory({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: _buildItems(context.view.getUserBy(id).exports!).toList()),
    );
  }

  Iterable<Widget> _buildItems(List<Export> exports) sync* {
    if (exports.isEmpty) {
      yield const Center(child: Text('It\'s Empty!'));
      return;
    }
    for (final Export export in exports) {
      if (!export.isMVC) {
        yield ExpansionTile(maintainState: true, title: Text(export.dateTime), children: <Widget>[
          CustomTable(columns: const <DataColumn>[
            DataColumn(label: Text('Prescription', style: ts18B)),
            DataColumn(label: Text('Detail', style: ts18B)),
          ], rows: <DataRow>[
            DataRow(cells: <DataCell>['Target load'.toCell, '${export.prescription!.targetLoad} Kg'.toCell]),
            DataRow(cells: <DataCell>['Sets #'.toCell, '${export.prescription!.sets}'.toCell]),
            DataRow(cells: <DataCell>['Reps #'.toCell, '${export.prescription!.reps}'.toCell]),
            DataRow(cells: <DataCell>['Hold time'.toCell, '${export.prescription!.holdTime} Sec'.toCell]),
            DataRow(cells: <DataCell>['Rest time'.toCell, '${export.prescription!.restTime} Sec'.toCell]),
            DataRow(cells: <DataCell>['Set rest time'.toCell, '${export.prescription!.setRest} Sec'.toCell]),
          ]),
        ]);
      }
    }
  }
}
