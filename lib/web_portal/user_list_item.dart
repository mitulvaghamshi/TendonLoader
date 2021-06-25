import 'package:flutter/material.dart';
import 'package:tendon_loader/app_state/app_state_scope.dart';
import 'package:tendon_loader/app_state/app_state_widget.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/exercise/new_exercise.dart';
import 'package:tendon_loader/modal/user.dart';
import 'package:tendon_loader/utils/item_action.dart';
import 'package:tendon_loader/utils/themes.dart';

class UserListItem extends StatelessWidget {
  const UserListItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: AppStateScope.of(context).users.length,
      separatorBuilder: (_, int index) => Divider(color: Theme.of(context).accentColor),
      itemBuilder: (_, int index) {
        final User _user = AppStateScope.of(context).users[index];
        return ExpansionTile(
          maintainState: true,
          key: ValueKey<String>(_user.id),
          subtitle: Text(_user.childCount),
          tilePadding: const EdgeInsets.all(5),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          leading: CustomButton(onPressed: () {}, color: Colors.blue, child: Text(_user.avatar)),
          title: Text(
            _user.id,
            style: const TextStyle(fontSize: 20, color: googleGreen, fontWeight: FontWeight.bold),
          ),
          trailing: PopupMenuButton<ItemAction>(
            icon: const Icon(Icons.apps_rounded),
            onSelected: (ItemAction action) async {
              if (action == ItemAction.download) {
                await _user.download();
              } else if (action == ItemAction.prescribe) {
                await showDialog<void>(
                  context: context,
                  builder: (_) => AlertDialog(
                    scrollable: true,
                    content: NewExercise(user: _user),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                );
              } else if (action == ItemAction.delete) {
                await showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      title: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: const <Widget>[
                        Icon(Icons.warning_rounded, size: 50),
                        Text('Do you really want to delete?'),
                      ]),
                      actions: <Widget>[
                        CustomButton(
                          onPressed: () async {
                            await _user.deleteAll();
                            AppStateWidget.of(context).refresh();
                          },
                          icon: const Icon(Icons.delete_rounded, color: red400),
                          child: const Text('Yes, Delete!', style: TextStyle(color: red400)),
                        ),
                        CustomButton(
                          onPressed: Navigator.of(context).pop,
                          icon: const Icon(Icons.cancel),
                          child: const Text('Cencel'),
                        ),
                      ],
                    );
                  },
                );
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
                  title: Text('Delete all', style: TextStyle(color: red400)),
                  leading: Icon(Icons.delete_forever_rounded, color: red400),
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
