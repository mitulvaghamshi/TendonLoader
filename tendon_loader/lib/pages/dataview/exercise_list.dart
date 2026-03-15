import 'package:api_server/api_server.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/pages/widgets/button_factory.dart';
import 'package:tendon_loader/pages/widgets/search_list.dart';
import 'package:tendon_loader/router/router.dart';

@immutable
class ExerciseList extends StatelessWidget {
  const ExerciseList({required this.title, required this.items, super.key});

  final String title;
  final Iterable<Exercise> items;

  @override
  Widget build(BuildContext context) => SearchList(
    items: items,
    title: title,
    searchLabel: 'Search by date...',
    searchTerm: (item) => item.datetime,
    builder: (item, index) => ButtonFactory.tile(
      onTap: () => ExerciseDetailsRoute(
        userId: item.userId,
        exerciseId: item.id,
      ).push<void>(context),
      spacing: 16,
      axisAlignment: .start,
      leading: CircleAvatar(child: Text(index.toString())),
      trailing: IconButton(
        onPressed: () => ExerciseDataListRoute(
          userId: item.userId,
          exerciseId: item.id,
        ).push<void>(context),
        icon: const Icon(Icons.format_list_numbered_sharp),
      ),
      child: Text(item.datetime),
    ),
  );
}
