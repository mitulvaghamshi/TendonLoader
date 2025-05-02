import 'package:flutter/material.dart';
import 'package:tendon_loader/models/exercise.dart';
import 'package:tendon_loader/router/router.dart';
import 'package:tendon_loader/ui/widgets/button_factory.dart';
import 'package:tendon_loader/ui/widgets/search_list.dart';

@immutable
class ExerciseList extends StatelessWidget {
  const ExerciseList({super.key, required this.title, required this.items});

  final String title;
  final Iterable<Exercise> items;

  @override
  Widget build(BuildContext context) {
    return SearchList(
      items: items,
      title: title,
      searchLabel: 'Search by date...',
      searchTerm: (item) => item.datetime,
      builder: (item, index) {
        return ButtonFactory.tile(
          spacing: 16,
          axisAlignment: MainAxisAlignment.start,
          leading: CircleAvatar(child: Text(index.toString())),
          trailing: IconButton(
            onPressed: () {
              ExerciseDataListRoute(
                userId: item.userId,
                exerciseId: item.id,
              ).push(context);
            },
            icon: const Icon(Icons.format_list_numbered_sharp),
          ),
          onTap: () {
            ExerciseDetaildRoute(
              userId: item.userId,
              exerciseId: item.id,
            ).push(context);
          },
          child: Text(item.datetime),
        );
      },
    );
  }
}
