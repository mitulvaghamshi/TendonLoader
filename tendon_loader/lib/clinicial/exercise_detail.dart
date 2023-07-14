import 'package:flutter/material.dart';
import 'package:tendon_loader/clinicial/data_graph.dart';
import 'package:tendon_loader/widgets/raw_button.dart';
import 'package:tendon_loader/models/exercise.dart';
import 'package:tendon_loader/models/prescription.dart';

@immutable
final class ExerciseDetail extends StatelessWidget {
  const ExerciseDetail({super.key, required this.data});

  final (Exercise?, Prescription?) data;

  @override
  Widget build(BuildContext context) {
    final items = [
      if (data.$1 != null) ...data.$1!.tableRows,
      if (data.$2 != null) ...data.$2!.tableRows,
    ];
    return CustomScrollView(slivers: [
      SliverAppBar.large(title: const Text('Exercise Details')),
      SliverToBoxAdapter(
        child: DataGraph(
          tagetLoad: data.$2?.targetLoad ?? data.$1?.mvcValue ?? 0,
          items: data.$1!.data,
        ),
      ),
      SliverList.builder(
        itemCount: items.length,
        itemBuilder: (context, index) => RawButton(
          child: Row(children: [
            Expanded(child: Text(items[index].$1)),
            Expanded(child: Text(items[index].$2)),
          ]),
        ),
      ),
    ]);
  }
}
