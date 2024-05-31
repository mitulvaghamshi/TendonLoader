import 'package:flutter/material.dart';
import 'package:tendon_loader/models/exercise.dart';
import 'package:tendon_loader/exercise/exercise_data_graph.dart';
import 'package:tendon_loader/api/services/exercise_service.dart';
import 'package:tendon_loader/models/chartdata.dart';
import 'package:tendon_loader/models/prescription.dart';
import 'package:tendon_loader/api/services/prescription_service.dart';
import 'package:tendon_loader/widgets/future_handler.dart';
import 'package:tendon_loader/widgets/raw_button.dart';

@immutable
final class ExerciseDetail extends StatelessWidget {
  const ExerciseDetail({
    super.key,
    required this.userId,
    required this.exerciseId,
  });

  final int userId;
  final int exerciseId;

  @override
  Widget build(BuildContext context) {
    return FutureHandler(
      future: _future,
      builder: (value) => CustomScrollView(slivers: [
        const SliverAppBar.large(title: Text('Exercise Details')),
        SliverToBoxAdapter(
          child: ExerciseDataGraph(
            tagetLoad: value.$1,
            items: value.$2,
          ),
        ),
        SliverList.builder(
          itemCount: value.$3.length,
          itemBuilder: (_, index) => _ListItem(row: value.$3.elementAt(index)),
        ),
      ]),
    );
  }
}

@immutable
final class _ListItem extends StatelessWidget {
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
  Future<(double, Iterable<ChartData>, Iterable<(String, String)>)>
      get _future async {
    final exercise =
        await ExerciseService.get(userId: userId, exerciseId: exerciseId);
    final prescriptionId = exercise?.prescriptionId;
    final prescription = prescriptionId == null
        ? null
        : await PrescriptionService.get(id: prescriptionId);
    return (
      prescription?.targetLoad ?? exercise?.mvcValue ?? 0,
      exercise?.data ?? [],
      [
        if (exercise != null) ...exercise.tableRows,
        if (prescription != null) ...prescription.tableRows,
      ],
    );
  }
}
