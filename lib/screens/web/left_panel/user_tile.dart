import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/modal/user.dart';
import 'package:tendon_loader/utils/enums.dart';
import 'package:tendon_loader/utils/helper.dart';
import 'package:tendon_loader/utils/textstyles.dart';
import 'package:tendon_loader/utils/themes.dart';

class UserTile extends StatelessWidget {
  const UserTile({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      maintainState: true,
      iconColor: colorAGreen400,
      key: ValueKey<String>(user.id),
      subtitle: Text(user.childCount),
      title: Text(user.id, style: ts18BFF),
      leading: CustomButton(child: Text(user.avatar)),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      trailing: PopupMenuButton<PopupAction>(
        icon: const Icon(Icons.apps),
        itemBuilder: (_) => <PopupMenuItem<PopupAction>>[
          const PopupMenuItem<PopupAction>(
            value: PopupAction.prescribe,
            child: ListTile(title: Text('Prescriptions'), leading: Icon(Icons.edit)),
          ),
          const PopupMenuItem<PopupAction>(
            value: PopupAction.download,
            child: ListTile(title: Text('Download all'), leading: Icon(Icons.file_download)),
          ),
          const PopupMenuItem<PopupAction>(
            value: PopupAction.delete,
            child: ListTile(
              leading: Icon(Icons.delete_forever, color: colorRed400),
              title: Text('Delete all', style: TextStyle(color: colorRed400)),
            ),
          ),
        ],
        onSelected: (PopupAction action) async {
          if (action == PopupAction.download) {
            await Future<void>.microtask(user.download);
          } else if (action == PopupAction.prescribe) {
            await user.prescribe(context);
          } else if (action == PopupAction.delete) {
            await confirmDelete(context, () async => user.deleteAll());
          }
        },
      ),
      children: ListTile.divideTiles(context: context, tiles: user.exportTiles()).toList(),
    );
  }
}
