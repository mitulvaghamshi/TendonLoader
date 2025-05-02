import 'package:flutter/material.dart';
import 'package:tendon_loader/models/user.dart';
import 'package:tendon_loader/router/router.dart';
import 'package:tendon_loader/ui/widgets/button_factory.dart';
import 'package:tendon_loader/ui/widgets/search_list.dart';
import 'package:tendon_loader/utils/constants.dart';

@immutable
class UserList extends StatelessWidget {
  const UserList({super.key, required this.items});

  final Iterable<User> items;

  @override
  Widget build(BuildContext context) {
    return SearchList(
      items: items,
      title: 'Enrolled Users',
      searchLabel: 'Search by name...',
      searchTerm: (item) => item.username,
      builder: (user, index) => _UserItem(user: user, index: index),
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
    return ButtonFactory.tile(
      onTap: () {
        ExerciseListRoute(userId: user.id!, title: user.name).push(context);
      },
      spacing: 16,
      axisAlignment: MainAxisAlignment.start,
      leading: CircleAvatar(radius: 24, child: Text(index.toString())),
      trailing: IconButton(
        onPressed: _showMenu,
        icon: const Icon(Icons.more_vert),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(user.name, style: Styles.bold18),
          Text(user.username, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

extension on _UserItem {
  // 1. Delete this user
  // 2. Download user data
  // 3. Allow web access
  // 4. Exercise History
  // 5. Edit Prescriptions
  void _showMenu() {
    throw UnimplementedError();
  }
}
