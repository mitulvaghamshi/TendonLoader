import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/shared/constants.dart';
import 'package:tendon_loader/shared/custom/custom_avater.dart';
import 'package:tendon_loader/shared/custom/custom_button.dart';
import 'package:tendon_loader/shared/modal/chartdata.dart';
import 'package:tendon_loader/shared/modal/prescription.dart';
import 'package:tendon_loader/shared/modal/session_info.dart';
import 'package:tendon_loader/web/handler/create_excel.dart';
import 'package:tendon_loader/web/handler/item_click_controller.dart';
import 'package:tendon_loader/web/handler/item_click_handler.dart';
import 'package:tendon_loader/web/panel/panel.dart';

class LeftPanel extends StatelessWidget with CreateExcel {
  const LeftPanel({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Panel(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection(Keys.KEY_ALL_USERS).snapshots(),
        builder: (_, AsyncSnapshot<QuerySnapshot> allUsers) {
          if (!allUsers.hasData) {
            return const CircularProgressIndicator();
          } else if (allUsers.hasError) {
            return const Text('Something wants wrong!.');
          }
          return Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: ListTile.divideTiles(
                color: Theme.of(context).accentColor,
                tiles: allUsers.data.docs.map<StreamBuilder<QuerySnapshot>>((QueryDocumentSnapshot user) {
                  return StreamBuilder<QuerySnapshot>(
                    stream: user.reference.collection(Keys.KEY_ALL_EXPORTS).snapshots(),
                    builder: (_, AsyncSnapshot<QuerySnapshot> allExports) {
                      if (!allExports.hasData) {
                        return const CircularProgressIndicator();
                      } else if (allExports.hasError) {
                        return const Text('Something wants wrong!.');
                      }
                      return ExpansionTile(
                        maintainState: true,
                        key: ValueKey<String>(user.id),
                        tilePadding: const EdgeInsets.all(5),
                        leading: TextAvatar(user.id[0].toUpperCase()),
                        expandedCrossAxisAlignment: CrossAxisAlignment.start,
                        title: Text(user.id, style: const TextStyle(fontSize: 18)),
                        children: ListTile.divideTiles(
                          color: Colors.deepOrange,
                          tiles: allExports.data.docs.map((QueryDocumentSnapshot dayExport) {
                            return _buildGroupItem(context, dayExport);
                          }),
                        ).toList(),
                      );
                    },
                  );
                }),
              ).toList(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGroupItem(BuildContext context, QueryDocumentSnapshot perDay) {
    final Map<String, dynamic> exports = perDay.data();
    if (exports.isEmpty) {
      return ListTile(
        onLongPress: () => perDay.reference.delete(),
        contentPadding: const EdgeInsets.all(5),
        title: Text('No exports available for "${perDay.id}"'),
        leading: TextAvatar(perDay.id.substring(8, 10), color: Colors.red),
        subtitle: const Text('Long press to remove empty container for this day from the server.'),
      );
    }
    return ExpansionTile(
      maintainState: true,
      key: ValueKey<String>(perDay.id),
      tilePadding: const EdgeInsets.all(5),
      leading: TextAvatar(perDay.id.substring(8, 10)),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      title: Text(perDay.id, style: const TextStyle(fontSize: 18)),
      subtitle: Text('${exports.length} export${exports.length == 1 ? '' : 's'} found.'),
      children: ListTile.divideTiles(
        color: Colors.deepOrange,
        tiles: exports.entries.map((MapEntry<String, dynamic> item) => _builldListItem(context, item)),
      ).toList(),
    );
  }

  Widget _builldListItem(BuildContext context, MapEntry<String, dynamic> export) {
    final Map<String, dynamic> _meta = export.value[Keys.KEY_META_DATA] as Map<String, dynamic>;
    final SessionInfo _info = SessionInfo.fromMap(_meta);
    final Prescription _pre = Prescription.fromMap(_meta);
    final List<ChartData> _dataList = List<Map<String, dynamic>>.from(export.value[Keys.KEY_USER_DATA] as List<dynamic>)
        .map<ChartData>((Map<String, dynamic> item) => ChartData.fromMap(item))
        .toList();
    return ListTile(
      onTap: () {
        if (_dataList.isNotEmpty) {
          ItemClickController.sink?.add(ItemClickHandler(
            dataList: _dataList,
            sessionInfo: _info,
            prescription: _pre,
          ));
        }
      },
      hoverColor: Colors.blue,
      key: ValueKey<String>(export.key),
      contentPadding: const EdgeInsets.all(5),
      subtitle: Text('Status: ${_info.dataStatus}'),
      leading: TextAvatar(_info.typeAbbr, color: _info.color),
      title: Text(export.key, style: const TextStyle(fontSize: 18)),
      trailing: PopupMenuButton<int>(
        onSelected: (int indexx) {},
        icon: const Icon(Icons.more_vert_rounded),
        itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[
          PopupMenuItem<int>(
            value: 1,
            child: CustomButton(
              simple: true,
              text: 'Download',
              icon: Icons.download_rounded,
              onPressed: () => create(data: _dataList, sessionInfo: _info, prescription: _pre),
            ),
          ),
          PopupMenuItem<int>(
            value: 2,
            child: CustomButton(
              simple: true,
              text: 'Delete',
              icon: Icons.delete_rounded,
              onPressed: () {
                FirebaseFirestore.instance
                    .collection(Keys.KEY_ALL_USERS)
                    .doc(_info.userId)
                    .collection(Keys.KEY_ALL_EXPORTS)
                    .doc(_info.exportDate)
                    .update(<String, dynamic>{export.key: FieldValue.delete()}).whenComplete(() {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Export deleted successfully!')),
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
// return ExpansionTile(
//   hoverColor: Colors.blue,
//   key: ValueKey<String>(user.id),
//   contentPadding: const EdgeInsets.all(10),
//   leading: TextAvatar(user.id[0].toUpperCase()),
//   title: Text(user.id, style: const TextStyle(fontSize: 18)),
//   onTap: () => UserReference.sink?.add(user.reference),
// );
