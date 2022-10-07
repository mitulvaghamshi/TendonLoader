import 'package:flutter/material.dart';
import 'package:tendon_loader/shared/models/export.dart';
import 'package:tendon_loader/shared/models/patient.dart';

@immutable
class ExerciseHistory extends StatelessWidget {
  ExerciseHistory({super.key, required this.user})
      : _exerciseList = user.exports!.where((Export e) => !e.isMVC);

  final Patient user;
  final Iterable<Export> _exerciseList;

  @override
  Widget build(BuildContext context) {
    if (_exerciseList.isEmpty) {
      return const Center(child: Text('It\'s Empty!'));
    }
    return SingleChildScrollView(
      primary: false,
      child: Column(children: _generateItems().toList()),
    );
  }

  Iterable<Widget> _generateItems() sync* {
    final Iterator<Export> iterator = _exerciseList.iterator;
    while (iterator.moveNext()) {
      final Export export = iterator.current;
      yield ExpansionTile(
        maintainState: true,
        title: Text(export.dateTime),
        iconColor: const Color(0xFF007AFF),
        textColor: const Color(0xFF007AFF),
        expandedAlignment: Alignment.centerLeft,
        children: <Widget>[export.prescription!.toTable()],
      );
    }
  }
}
