import 'package:flutter/material.dart';
import 'package:tendon_loader/app_state/app_state_widget.dart';
import 'package:tendon_loader/modal/export.dart';

@immutable
class ExerciseHistory extends StatelessWidget {
  const ExerciseHistory({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: _buildItems(
          AppStateWidget.of(context).getUserBy(id).exports!,
        ).toList(),
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
