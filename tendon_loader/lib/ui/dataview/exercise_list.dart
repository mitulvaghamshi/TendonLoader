import 'package:flutter/material.dart';
import 'package:tendon_loader/router/router.dart';
import 'package:tendon_loader/services/exercise_service.dart';
import 'package:tendon_loader/ui/widgets/future_wrapper.dart';
import 'package:tendon_loader/ui/widgets/raw_button.dart';
import 'package:tendon_loader/ui/widgets/search_list.dart';

@immutable
class ExerciseList extends StatelessWidget {
  const ExerciseList({super.key, required this.userId, required this.title});

  final int userId;
  final String title;

  @override
  Widget build(BuildContext context) {
    return FutureWrapper(
      future: ExerciseService.instance.getAllExercisesByUserId(userId),
      builder: (items) => SearchList(
        title: title,
        searchLabel: 'Search by date...',
        items: items.requireData,
        searchTerm: (item) => item.datetime,
        builder: (item, index) => RawButton.tile(
          leadingToChildSpace: 16,
          axisAlignment: MainAxisAlignment.start,
          leading: CircleAvatar(child: Text(index.toString())),
          trailing: IconButton(
            onPressed: () => ExerciseDataListRoute(
              userId: item.userId,
              exerciseId: item.id,
            ).push(context),
            icon: const Icon(Icons.format_list_numbered_sharp),
          ),
          onTap: () => ExerciseDetaildRoute(
            userId: item.userId,
            exerciseId: item.id,
          ).push(context),
          child: Text(item.datetime),
        ),
      ),
    );
  }
}
