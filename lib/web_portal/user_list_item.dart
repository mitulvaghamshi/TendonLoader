import 'package:flutter/material.dart';
import 'package:tendon_loader/app_state/app_state_scope.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/modal/user.dart';
import 'package:tendon_loader/utils/item_action.dart';
import 'package:tendon_loader/web_portal/new_prescription.dart';

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
          title: Text(_user.id, style: const TextStyle(fontSize: 18)),
          leading: CustomButton(text: Text(_user.avatar), color: Colors.blue),
          trailing: PopupMenuButton<ItemAction>(
            icon: const Icon(Icons.more_vert_rounded),
            onSelected: (ItemAction action) async {
              if (action == ItemAction.download) {
                await _user.download();
              } else if (action == ItemAction.prescribe) {
                await showDialog<void>(
                  context: context,
                  builder: (_) => AlertDialog(
                    scrollable: true,
                    content: const NewPrescription(),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                );
              }
            },
            itemBuilder: (_) => <PopupMenuItem<ItemAction>>[
              const PopupMenuItem<ItemAction>(
                value: ItemAction.download,
                child: ListTile(
                  title: Text('Download all'),
                  leading: Icon(Icons.file_download_rounded),
                ),
              ),
              const PopupMenuItem<ItemAction>(
                value: ItemAction.prescribe,
                child: ListTile(
                  title: Text('Prescription'),
                  leading: Icon(Icons.app_registration_rounded),
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
