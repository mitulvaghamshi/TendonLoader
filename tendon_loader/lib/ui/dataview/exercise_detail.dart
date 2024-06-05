import 'package:flutter/material.dart';
import 'package:tendon_loader/models/chartdata.dart';
import 'package:tendon_loader/models/exercise.dart';
import 'package:tendon_loader/models/prescription.dart';
import 'package:tendon_loader/services/exercise_service.dart';
import 'package:tendon_loader/services/prescription_service.dart';
import 'package:tendon_loader/ui/dataview/exercise_data_graph.dart';
import 'package:tendon_loader/ui/widgets/future_wrapper.dart';
import 'package:tendon_loader/ui/widgets/raw_button.dart';
import 'package:tendon_loader/utils/states/app_scope.dart';

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
    final exerciseService = AppScope.of(context).exerciseService;
    final prescriptionService = AppScope.of(context).prescriptionService;
    return FutureWrapper(
      future: _future(exerciseService, prescriptionService),
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
          itemBuilder: (context, index) => _ListItem(
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
  Future<_DataSet> _future(
    final ExerciseService exerciseService,
    final PrescriptionService prescriptionService,
  ) async {
    final exercise =
        await exerciseService.getBy(userId: userId, exerciseId: exerciseId);
    if (exercise == null) throw '[ExerciseDetail]: Exercise is null.';

    final prescriptionId = exercise.prescriptionId;
    final prescription = prescriptionId == null
        ? null
        : await prescriptionService.getBy(id: prescriptionId);

    return (
      targetLoad: prescription?.targetLoad ?? exercise.mvcValue ?? 0,
      chartData: exercise.data,
      infoTable: [
        ...exercise.tableRows,
        if (prescription != null) ...prescription.tableRows,
      ],
    );
  }
}

typedef _DataSet = ({
  double targetLoad,
  Iterable<ChartData> chartData,
  Iterable<(String, String)> infoTable,
});
