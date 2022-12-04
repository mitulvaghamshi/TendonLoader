import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/common/models/export.dart';
import 'package:tendon_loader/screens/web/widgets/prescription_view.dart';

class ExerciseHistory extends StatelessWidget {
  const ExerciseHistory({super.key, required this.exerciseList});

  final Iterable<Export> exerciseList;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Exercise History'),
      ),
      child: CustomScrollView(
        semanticChildCount: exerciseList.length,
        slivers: <Widget>[
          SliverSafeArea(
            minimum: const EdgeInsets.all(8),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((_, int index) {
                if (index < exerciseList.length) {
                  final Export export = exerciseList.elementAt(index);
                  return ExpansionTile(
                    title: Text(export.dateTime),
                    expandedAlignment: Alignment.centerRight,
                    children: <Widget>[
                      PrescriptionView.prescription(export.prescription!),
                    ],
                  );
                }
                return null;
              }),
            ),
          ),
        ],
      ),
    );
  }
}
