import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tendon_loader/models/user.dart';
import 'package:tendon_loader/router/router.dart';
import 'package:tendon_loader/ui/widgets/future_wrapper.dart';
import 'package:tendon_loader/ui/widgets/raw_button.dart';
import 'package:tendon_loader/ui/widgets/search_list_builder.dart';
import 'package:tendon_loader/utils/constants.dart';
import 'package:tendon_loader/utils/states/app_scope.dart';

@immutable
class UserList extends StatelessWidget {
  const UserList({super.key});

  @override
  Widget build(BuildContext context) {
    final service = AppScope.of(context).userService;
    return FutureWrapper(
      future: service.getAll(),
      builder: (snapshot) {
        if (snapshot.hasData) {
          return SearchListBuilder(
            title: 'Enrolled Users',
            searchLabel: 'Search by name...',
            items: snapshot.requireData,
            searchField: (item) => item.username,
            builder: _UserItem.builder,
          );
        }
        return RawButton.error(message: snapshot.error.toString());
      },
    );
  }
}

@immutable
class _UserItem extends StatelessWidget {
  const _UserItem({required this.user, required this.index});

  factory _UserItem.builder(User user, int index) =>
      _UserItem(user: user, index: index);

  final User user;
  final int index;

  @override
  Widget build(BuildContext context) {
    return RawButton.tile(
      leadingToChildSpace: 16,
      axisAlignment: MainAxisAlignment.start,
      leading: CircleAvatar(radius: 24, child: Text(index.toString())),
      trailing: IconButton(
        onPressed: () {
          // TODO(me): Add context menu with options:
          // 1. itemDelete,
          // 2. itemDownload,
          // 3. Allow web access,
          // 4. Exercise History,
          // 5. Edit Prescriptions
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
  }
}

// TODO(me): implement...
@immutable
class ManageUserinfo extends StatefulWidget {
  const ManageUserinfo({super.key, required this.user});

  final User user;

  @override
  State<ManageUserinfo> createState() => _ManageUserinfoState();
}

class _ManageUserinfoState extends State<ManageUserinfo> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
