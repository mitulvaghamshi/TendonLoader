import 'package:flutter/material.dart';
import 'package:tendon_loader/models/chartdata.dart';
import 'package:tendon_loader/models/exercise.dart';
import 'package:tendon_loader/models/prescription.dart';
import 'package:tendon_loader/services/exercise_service.dart';
import 'package:tendon_loader/services/prescription_service.dart';
import 'package:tendon_loader/ui/dataview/exercise_data_graph.dart';
import 'package:tendon_loader/ui/widgets/future_wrapper.dart';
import 'package:tendon_loader/ui/widgets/raw_button.dart';

@immutable
class ExerciseDetail extends StatelessWidget {
  const ExerciseDetail({
    super.key,
    required this.userId,
    required this.exerciseId,
  });

  final int userId;
  final int exerciseId;

  @override
  Widget build(BuildContext context) {
    return FutureWrapper(
      future: _future,
      builder: (value) => CustomScrollView(slivers: [
        const SliverAppBar.large(title: Text('Exercise Details')),
        SliverToBoxAdapter(
          child: ExerciseDataGraph(
            tagetLoad: value.targetLoad,
            items: value.chartData,
          ),
        ),
        SliverList.builder(
          itemCount: value.infoTable.length,
          itemBuilder: (_, index) => _ListItem(
            row: value.infoTable.elementAt(index),
          ),
        ),
      ]),
    );
  }
}

@immutable
class _ListItem extends StatelessWidget {
  const _ListItem({required this.row});

  final (String, String) row;

  @override
  Widget build(BuildContext context) {
    return RawButton(
      child: Row(children: [
        Expanded(child: Text(row.$1)),
        Expanded(child: Text(row.$2)),
      ]),
    );
  }
}

extension on ExerciseDetail {
  Future<_DataSet> get _future async {
    final eSnapshot = await ExerciseService.instance
        .getExerciseBy(userId: userId, exerciseId: exerciseId);

    if (eSnapshot.hasError) {
      return (
        targetLoad: 0.0,
        chartData: const Iterable<ChartData>.empty(),
        infoTable: const Iterable<(String, String)>.empty(),
      );
    }

    final exercise = eSnapshot.requireData;

    final pSnapshot = await PrescriptionService.instance
        .getPrescriptionById(exercise.prescriptionId);

    if (pSnapshot.hasError) {
      return (
        targetLoad: exercise.mvcValue ?? 0.0,
        chartData: exercise.data,
        infoTable: exercise.tableRows,
      );
    }

    final prescription = pSnapshot.requireData;
    return (
      targetLoad: prescription.targetLoad,
      chartData: exercise.data,
      infoTable: [...exercise.tableRows, ...prescription.tableRows],
    );
  }
}

typedef _DataSet = ({
  double targetLoad,
  Iterable<ChartData> chartData,
  Iterable<(String, String)> infoTable,
});
