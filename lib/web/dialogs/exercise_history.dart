import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_frame.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/modal/patient.dart';

@immutable
class ExerciseHistory extends StatelessWidget {
  const ExerciseHistory({Key? key, required this.patient}) : super(key: key);

  final Patient patient;

  @override
  Widget build(BuildContext context) {
    return AppFrame(
      child: SingleChildScrollView(
        child: Column(children: _buildItems(patient.exports!).toList()),
      ),
    );
  }

  Iterable<Widget> _buildItems(List<Export> exports) sync* {
    if (exports.isEmpty) {
      yield const Center(child: Text('It\'s Empty!'));
      return;
    }
    for (final Export export in exports) {
      if (!export.isMVC) {
        yield ExpansionTile(
          maintainState: true,
          title: Text(export.dateTime),
          children: <Widget>[export.prescription!.toTable()],
        );
      }
    }
  }
}
