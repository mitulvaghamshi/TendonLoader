import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/shared/constants.dart';
import 'package:tendon_loader/shared/custom/custom_avater.dart';
import 'package:tendon_loader/shared/custom/custom_button.dart';
import 'package:tendon_loader/shared/custom/custom_frame.dart';
import 'package:tendon_loader/shared/custom/custom_progress.dart';
import 'package:tendon_loader/shared/modal/chartdata.dart';
import 'package:tendon_loader/shared/modal/data_model.dart';
import 'package:tendon_loader/shared/modal/prescription.dart';
import 'package:tendon_loader/shared/modal/session_info.dart';
import 'package:tendon_loader/web/handler/click_handler.dart';
import 'package:tendon_loader/web/handler/create_excel.dart';

enum ItemAction { download, delete }

class LeftPanel extends StatefulWidget {
  const LeftPanel({Key key}) : super(key: key);

  @override
  _LeftPanelState createState() => _LeftPanelState();
}

class _LeftPanelState extends State<LeftPanel> with CreateExcel {
  final TextEditingController searchCtrl = TextEditingController();

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppFrame(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection(Keys.KEY_ALL_USERS).snapshots(),
        builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
          return snapshot.hasData ? _buildUsers(snapshot.data.docs) : const CustomProgress();
        },
      ),
    );
  }

  ListView _buildUsers(List<QueryDocumentSnapshot> users) {
    return ListView.separated(
      itemCount: users.length,
      separatorBuilder: (_, int index) => Divider(color: Theme.of(context).accentColor),
      itemBuilder: (_, int index) => StreamBuilder<QuerySnapshot>(
        stream: users[index].reference.collection(Keys.KEY_ALL_EXPORTS).snapshots(),
        builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: snapshot.hasData
                ? ExpansionTile(
                    maintainState: true,
                    key: ValueKey<String>(users[index].id),
                    tilePadding: const EdgeInsets.all(5),
                    leading: CustomAvatar(users[index].id[0].toUpperCase()),
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    title: Text(users[index].id, style: const TextStyle(fontSize: 18)),
                    children: ListTile.divideTiles(
                      color: Colors.blue,
                      tiles: snapshot.data.docs.map(_buildGroupItem),
                    ).toList(),
                  )
                : const SizedBox(height: 50),
          );
        },
      ),
    );
  }

  Widget _buildGroupItem(QueryDocumentSnapshot perDay) {
    final Map<String, dynamic> exports = perDay.data();
    if (exports.isEmpty) {
      return ListTile(
        contentPadding: const EdgeInsets.all(5),
        onLongPress: () => perDay.reference.delete(),
        title: Text(perDay.id, style: const TextStyle(fontSize: 18)),
        subtitle: const Text('Long press to delete from the server.'),
        leading: CustomAvatar(perDay.id.substring(8, 10), color: Colors.red),
      );
    }
    return ExpansionTile(
      maintainState: true,
      key: ValueKey<String>(perDay.id),
      tilePadding: const EdgeInsets.all(5),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      title: Text(perDay.id, style: const TextStyle(fontSize: 18)),
      leading: CustomAvatar(perDay.id.substring(8, 10), color: Colors.blue),
      subtitle: Text('${exports.length} export${exports.length == 1 ? '' : 's'} found.'),
      children: ListTile.divideTiles(
        color: Theme.of(context).accentColor,
        tiles: exports.entries.map(_builldListItem),
      ).toList(),
    );
  }

  Widget _builldListItem(MapEntry<String, dynamic> export) {
    final Map<String, dynamic> _meta = export.value[Keys.KEY_META_DATA] as Map<String, dynamic>;
    final SessionInfo _info = SessionInfo.fromMap(_meta);
    final Prescription _pre = _info.type ? null : Prescription.fromMap(_meta);
    final List<ChartData> _dataList = List<Map<String, dynamic>>.from(export.value[Keys.KEY_USER_DATA] as List<dynamic>)
        .map<ChartData>((Map<String, dynamic> item) => ChartData.fromMap(item))
        .toList();
    return ListTile(
      key: ValueKey<String>(export.key),
      contentPadding: const EdgeInsets.all(5),
      subtitle: Text('Status: ${_info.dataStatus}'),
      leading: CustomAvatar(_info.abbr, color: _info.color),
      title: Text(export.key, style: const TextStyle(fontSize: 18)),
      onTap: () {
        if (_dataList.isNotEmpty) {
          ClickHandler.sink?.add(DataModel(dataList: _dataList, sessionInfo: _info, prescription: _pre));
        }
      },
      trailing: PopupMenuButton<ItemAction>(
        icon: const Icon(Icons.more_vert_rounded),
        itemBuilder: (_) => <PopupMenuItem<ItemAction>>[
          const PopupMenuItem<ItemAction>(
            value: ItemAction.download,
            child: ListTile(title: Text('Download'), leading: Icon(Icons.download_rounded)),
          ),
          const PopupMenuItem<ItemAction>(
            value: ItemAction.delete,
            child: ListTile(title: Text('Delete'), leading: Icon(Icons.delete_rounded)),
          ),
        ],
        onSelected: (ItemAction action) async {
          switch (action) {
            case ItemAction.download:
              create(data: _dataList, sessionInfo: _info, prescription: _pre);
              break;
            case ItemAction.delete:
              await showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const <Widget>[
                        Icon(Icons.warning_rounded, size: 50, color: Colors.red),
                        Text('Do you really want to delete?'),
                      ],
                    ),
                    actions: <Widget>[
                      CustomButton(
                        text: 'Yes, Delete!',
                        icon: Icons.delete_rounded,
                        background: Colors.red,
                        onPressed: () async {
                          Navigator.pop(context);
                          await FirebaseFirestore.instance
                              .collection(Keys.KEY_ALL_USERS)
                              .doc(_info.userId)
                              .collection(Keys.KEY_ALL_EXPORTS)
                              .doc(_info.exportDate)
                              .update(<String, dynamic>{export.key: FieldValue.delete()});
                        },
                      ),
                      CustomButton(text: 'Cencel', icon: Icons.cancel, onPressed: Navigator.of(context).pop),
                    ],
                    actionsPadding: const EdgeInsets.only(bottom: 10, left: 50, right: 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  );
                },
              );
              break;
          }
        },
      ),
    );
  }
}
