import 'package:flutter/material.dart';
import 'package:tendon_loader/common/widgets/raw_button.dart';
import 'package:tendon_loader/models/exercise.dart';
import 'package:tendon_loader/screens/web/widgets/search_field.dart';

@immutable
final class ExerciseList extends StatefulWidget {
  const ExerciseList({super.key, required this.title, required this.items});

  final String title;
  final Iterable<Exercise> items;

  @override
  State<ExerciseList> createState() => _ExerciseListState();
}

final class _ExerciseListState extends State<ExerciseList> {
  final _searchCtrl = TextEditingController();
  late Iterable<Exercise> searchList = widget.items;

  void _search() {
    final term = _searchCtrl.text.toLowerCase();
    final list =
        term.isEmpty ? widget.items : widget.items.where((e) => e.match(term));
    setState(() => searchList = list);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
      SliverAppBar.large(title: Text(widget.title)),
      SliverList.builder(
        itemCount: searchList.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return SearchField(
              label: 'Search by date...',
              controller: _searchCtrl,
              onSearch: _search,
            );
          } else if (index <= searchList.length) {
            final exercise = searchList.elementAt(index - 1);
            return RawButton.tile(
              onTap: () {},
              leadingToTitleSpace: 16,
              axisAlignment: MainAxisAlignment.start,
              leading: CircleAvatar(child: Text(index.toString())),
              trailing: const Icon(Icons.chevron_right),
              child: Text(exercise.datetime),
            );
          }
          return null;
        },
      ),
    ]);
  }
}
