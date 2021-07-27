import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_progress.dart';
import 'package:tendon_loader/screens/web/left_panel/user_tile.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/themes.dart';

class UserList extends StatelessWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: colorGoogleGreen,
      onRefresh: () async => context
        ..model.reload()
        ..view.refresh(),
      child: FutureBuilder<void>(
        future: context.model.fetch(),
        builder: (_, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) return const CustomProgress();
          return ListView.separated(
            itemCount: context.model.users.length,
            separatorBuilder: (_, __) => const Divider(height: 0),
            itemBuilder: (_, int index) => UserTile(user: context.model.users[index]),
          );
        },
      ),
    );
  }
}
