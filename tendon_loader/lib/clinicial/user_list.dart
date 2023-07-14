import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tendon_loader/signin/user.dart';
import 'package:tendon_loader/common/constants.dart';
import 'package:tendon_loader/widgets/input_widget.dart';
import 'package:tendon_loader/widgets/raw_button.dart';
import 'package:tendon_loader/router/router.dart';

@immutable
final class UserList extends StatefulWidget {
  const UserList({super.key, required this.items});

  final Iterable<User> items;

  @override
  State<UserList> createState() => _UserListState();
}

final class _UserListState extends State<UserList> {
  final _searchCtrl = TextEditingController();
  late Iterable<User> searchList = widget.items;

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
      SliverAppBar.large(title: const Text('Enrolled Users')),
      SliverList.builder(
        itemCount: searchList.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return InputWidget.search(
              label: 'Search by name...',
              controller: _searchCtrl,
              onComplete: _search,
            );
          }
          final user = searchList.elementAt(index - 1);
          return RawButton.tile(
            leadingToTitleSpace: 16,
            axisAlignment: MainAxisAlignment.start,
            leading: CircleAvatar(radius: 24, child: Text(index.toString())),
            trailing: IconButton(
              onPressed: () {
                // TODO(me): Implement view to manage these options:
                // itemDelete,
                // itemDownload,
                // Allow web access
                // Exercise History
                // Edit Prescriptions
              },
              icon: const Icon(Icons.settings),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name, style: Styles.titleStyle),
                Text(
                  user.username,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            onTap: () => context.push(
              const ExerciseListRoute().location,
              extra: {'userId': user.id, 'title': user.name},
            ),
          );
        },
      ),
    ]);
  }
}
