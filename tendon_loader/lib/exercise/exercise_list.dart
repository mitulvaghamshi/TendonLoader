import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tendon_loader/exercise/exercise_service.dart';
import 'package:tendon_loader/router/router.dart';
import 'package:tendon_loader/widgets/future_handler.dart';
import 'package:tendon_loader/widgets/raw_button.dart';
import 'package:tendon_loader/widgets/search_list_builder.dart';

@immutable
final class ExerciseList extends StatelessWidget {
  const ExerciseList({
    super.key,
    required this.userId,
    required this.title,
  });

  final int userId;
  final String title;

  @override
  Widget build(BuildContext context) {
    return FutureHandler(
      future: ExerciseService.getAllBy(userId: userId),
      builder: (items) => SearchListBuilder(
        title: title,
        searchLabel: 'Search by date...',
        items: items,
        searchField: (item) => item.datetime,
        builder: (item, index) {
          final extra = {'userId': item.userId, 'exerciseId': item.id};
          return RawButton.tile(
            leadingToTitleSpace: 16,
            axisAlignment: MainAxisAlignment.start,
            leading: CircleAvatar(child: Text(index.toString())),
            trailing: IconButton(
              onPressed: () => context.push(
                const ExerciseDataListRoute().location,
                extra: extra,
              ),
              icon: const Icon(Icons.format_list_numbered_sharp),
            ),
            onTap: () => context.push(
              const ExerciseDetaildRoute().location,
              extra: extra,
            ),
            child: Text(item.datetime),
          );
        },
      ),
    );
  }
}
