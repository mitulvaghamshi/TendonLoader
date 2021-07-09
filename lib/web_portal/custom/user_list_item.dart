import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/utils/helper.dart';
import 'package:tendon_loader/modal/user.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/item_action.dart';
import 'package:tendon_loader/utils/themes.dart';

class UserListItem extends StatelessWidget {
  const UserListItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: context.model.users.length,
      separatorBuilder: (_, int index) => Divider(color: Theme.of(context).accentColor),
      itemBuilder: (_, int index) {
        final User _user = context.model.users[index];
        return ExpansionTile(
          maintainState: true,
          key: ValueKey<String>(_user.id),
          subtitle: Text(_user.childCount),
          tilePadding: const EdgeInsets.all(5),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          leading: CustomButton(color: Colors.blue, child: Text(_user.avatar)),
          title: Text(
            _user.id,
            style: const TextStyle(
              fontSize: 18,
              color: colorGoogleGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: PopupMenuButton<ItemAction>(
            icon: const Icon(Icons.apps_rounded),
            onSelected: (ItemAction action) async {
              if (action == ItemAction.download) {
                await Future<void>.microtask(_user.download);
              } else if (action == ItemAction.prescribe) {
                await setPrescriptions(context, _user);
              } else if (action == ItemAction.delete) {
                await confirmDelete(context, () async {
                  Navigator.pop(context);
                  context.view.refresh;
                  await Future<void>.microtask(_user.deleteAllExports);
                });
              }
            },
            itemBuilder: (_) => <PopupMenuItem<ItemAction>>[
              const PopupMenuItem<ItemAction>(
                value: ItemAction.prescribe,
                child: ListTile(
                  title: Text('Prescription'),
                  leading: Icon(Icons.edit_rounded),
                ),
              ),
              const PopupMenuItem<ItemAction>(
                value: ItemAction.download,
                child: ListTile(
                  title: Text('Download all'),
                  leading: Icon(Icons.file_download_rounded),
                ),
              ),
              const PopupMenuItem<ItemAction>(
                value: ItemAction.delete,
                child: ListTile(
                  title: Text('Delete all', style: TextStyle(color: colorRed400)),
                  leading: Icon(Icons.delete_forever_rounded, color: colorRed400),
                ),
              ),
            ],
          ),
          children: ListTile.divideTiles(color: Colors.blue, tiles: _user.exportTiles).toList(),
        );
      },
    );
  }
}
