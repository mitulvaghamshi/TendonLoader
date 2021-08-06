import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/modal/user.dart';
import 'package:tendon_loader/screens/homepage.dart';
import 'package:tendon_loader/screens/web/popup_menu.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/themes.dart';

class UserTile extends StatelessWidget {
  const UserTile({Key? key, required this.id, this.filter}) : super(key: key);

  final int id;
  final String? filter;

  @override
  Widget build(BuildContext context) {
    final User user = context.model.getUserById(id);
    return ExpansionTile(
      maintainState: true,
      textColor: colorBlue,
      key: ValueKey<int>(id),
      subtitle: Text(user.childCount),
      title: Text(user.id, style: ts18B),
      tilePadding: const EdgeInsets.all(5),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      leading: CustomButton(rounded: true, left: Text(user.avatar, style: ts18B)),
      trailing: PopupMenu(
        isUser: true,
        onSelected: (PopupAction action) async {
          if (action == PopupAction.download) {
            await Future<void>.microtask(user.download);
          } else if (action == PopupAction.prescribe) {
            await user.prescribe(context);
          } else if (action == PopupAction.delete) {
            await confirmDelete(context, user.deleteAll);
          }
        },
      ),
      children: ListTile.divideTiles(context: context, tiles: user.exportTiles(filter)).toList(),
    );
  }
}
