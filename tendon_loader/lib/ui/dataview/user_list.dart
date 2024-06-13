import 'package:flutter/material.dart';
import 'package:tendon_loader/models/user.dart';
import 'package:tendon_loader/router/router.dart';
import 'package:tendon_loader/services/user_service.dart';
import 'package:tendon_loader/ui/widgets/future_wrapper.dart';
import 'package:tendon_loader/ui/widgets/raw_button.dart';
import 'package:tendon_loader/ui/widgets/search_list.dart';
import 'package:tendon_loader/utils/constants.dart';

@immutable
class UserList extends StatelessWidget {
  const UserList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureWrapper(
      future: UserService.instance.getAllUsers(),
      builder: (snapshot) {
        if (snapshot.hasData) {
          return SearchList(
            title: 'Enrolled Users',
            searchLabel: 'Search by name...',
            items: snapshot.requireData,
            searchTerm: (item) => item.username,
            builder: (user, index) => _UserItem(user: user, index: index),
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

  final User user;
  final int index;

  @override
  Widget build(BuildContext context) {
    return RawButton.tile(
      onTap: () => ExerciseListRoute(
        userId: user.id!,
        title: user.name,
      ).push(context),
      leadingToChildSpace: 16,
      axisAlignment: MainAxisAlignment.start,
      leading: CircleAvatar(radius: 24, child: Text(index.toString())),
      trailing: IconButton(
        onPressed: _showMenu,
        icon: const Icon(Icons.more_vert),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(user.name, style: Styles.bold18),
        Text(user.username, style: const TextStyle(color: Colors.grey)),
      ]),
    );
  }
}

extension on _UserItem {
  // TODO(me): Add context menu with options:
  // 1. Delete this user
  // 2. Download user data
  // 3. Allow web access
  // 4. Exercise History
  // 5. Edit Prescriptions
  void _showMenu() {}
}
