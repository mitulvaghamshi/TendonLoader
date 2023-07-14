import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/models/exercise.dart';
import 'package:tendon_loader/models/prescription.dart';
import 'package:tendon_loader/screens/web/widgets/prescription_view.dart';

class ExerciseHistory extends StatelessWidget {
  const ExerciseHistory({
    super.key,
    /* required this.exerciseList */
  });

  @override
  Widget build(BuildContext context) {
    final Iterable<Exercise> exerciseList = [];
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Exercise History'),
      ),
      child: CustomScrollView(
        semanticChildCount: 0,
        slivers: [
          SliverSafeArea(
            minimum: const EdgeInsets.all(8),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((_, index) {
                if (index < exerciseList.length) {
                  final Exercise export = exerciseList.elementAt(index);
                  return ExpansionTile(
                    title: Text(export.datetime),
                    expandedAlignment: Alignment.centerRight,
                    children: [
                      PrescriptionView.prescription(const Prescription.empty()),
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
