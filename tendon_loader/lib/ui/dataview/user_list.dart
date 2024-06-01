import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tendon_loader/api/services/user_service.dart';
import 'package:tendon_loader/models/user.dart';
import 'package:tendon_loader/router/router.dart';
import 'package:tendon_loader/ui/widgets/future_handler.dart';
import 'package:tendon_loader/ui/widgets/raw_button.dart';
import 'package:tendon_loader/ui/widgets/search_list_builder.dart';
import 'package:tendon_loader/utils/constants.dart';

@immutable
final class UserList extends StatelessWidget {
  const UserList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureHandler(
      future: UserService.getAll(),
      builder: (items) => SearchListBuilder(
        title: 'Enrolled Users',
        searchLabel: 'Search by name...',
        items: items,
        searchField: (item) => item.username,
        builder: (item, index) => RawButton.tile(
          leadingToChildSpace: 16,
          axisAlignment: MainAxisAlignment.start,
          leading: CircleAvatar(radius: 24, child: Text(index.toString())),
          trailing: IconButton(
            onPressed: () {
              // TODO(me): itemDelete, itemDownload, Allow web access,
              // Exercise History, Edit Prescriptions
            },
            icon: const Icon(Icons.settings),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.name, style: Styles.titleStyle),
              Text(
                item.username,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          onTap: () => context.push(
            const ExerciseListRoute().location,
            extra: {'userId': item.id, 'title': item.name},
          ),
        ),
      ),
    );
  }
}

// TODO(me): implement...
@immutable
final class ManageUserinfo extends StatefulWidget {
  const ManageUserinfo({super.key, required this.user});

  final User user;

  @override
  State<ManageUserinfo> createState() => _ManageUserinfoState();
}

final class _ManageUserinfoState extends State<ManageUserinfo> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
