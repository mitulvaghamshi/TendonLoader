import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/models/exercise.dart';
import 'package:tendon_loader/screens/web/data_graph.dart';
import 'package:tendon_loader/screens/web/exercise_data_list.dart';

class ExerciseView extends StatefulWidget {
  const ExerciseView({super.key});

  @override
  State<ExerciseView> createState() => _ExerciseViewState();
}

class _ExerciseViewState extends State<ExerciseView> {
  late final export = const Exercise.empty();
  // AppScope.of(context).userState.excercise;
  bool _showList = true;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        if (constraints.biggest.width > 600) {
          return const CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text('export.fileName'),
            ),
            child: Row(children: [
              SizedBox(width: 300, child: ExerciseDataList()),
              VerticalDivider(width: 2, thickness: 2),
              Expanded(child: DataGraph()),
            ]),
          );
        }
        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text(export.datetime),
            trailing: CupertinoButton(
              onPressed: () => setState(() => _showList = !_showList),
              child: Icon(_showList ? Icons.show_chart : Icons.list),
            ),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: _showList ? const ExerciseDataList() : const DataGraph(),
          ),
        );
      },
    );
  }
}
