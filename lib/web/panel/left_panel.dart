import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/shared/constants.dart';
import 'package:tendon_loader/shared/custom/custom_avater.dart';
import 'package:tendon_loader/shared/custom/custom_frame.dart';
import 'package:tendon_loader/shared/custom/custom_progress.dart';
import 'package:tendon_loader/shared/modal/chartdata.dart';
import 'package:tendon_loader/shared/modal/prescription.dart';
import 'package:tendon_loader/shared/modal/session_info.dart';
import 'package:tendon_loader/web/handler/create_excel.dart';
import 'package:tendon_loader/web/handler/item_click_controller.dart';
import 'package:tendon_loader/web/handler/item_click_handler.dart';

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
        builder: (_, AsyncSnapshot<QuerySnapshot> allUsers) {
          if (!allUsers.hasData) return const CustomProgress();
          return ListView(
            physics: const BouncingScrollPhysics(),
            children: ListTile.divideTiles(
              color: Theme.of(context).accentColor,
              tiles: allUsers.data.docs.map<StreamBuilder<QuerySnapshot>>((QueryDocumentSnapshot user) {
                return StreamBuilder<QuerySnapshot>(
                  stream: user.reference.collection(Keys.KEY_ALL_EXPORTS).snapshots(),
                  builder: (_, AsyncSnapshot<QuerySnapshot> allExports) {
                    if (!allExports.hasData) return const CustomProgress();
                    return ExpansionTile(
                      maintainState: true,
                      key: ValueKey<String>(user.id),
                      tilePadding: const EdgeInsets.all(5),
                      leading: CustomAvatar(user.id[0].toUpperCase()),
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      title: Text(user.id, style: const TextStyle(fontSize: 18)),
                      children: ListTile.divideTiles(
                        color: Colors.blue,
                        tiles: allExports.data.docs.map(_buildGroupItem),
                      ).toList(),
                    );
                  },
                );
              }),
            ).toList(),
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
      leading: CustomAvatar(perDay.id.substring(8, 10)),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      title: Text(perDay.id, style: const TextStyle(fontSize: 18)),
      subtitle: Text('${exports.length} export${exports.length == 1 ? '' : 's'} found.'),
      children: ListTile.divideTiles(
        color: Colors.deepOrange,
        tiles: exports.entries.map(_builldListItem),
      ).toList(),
    );
  }

  Widget _builldListItem(MapEntry<String, dynamic> export) {
    final Map<String, dynamic> _meta = export.value[Keys.KEY_META_DATA] as Map<String, dynamic>;
    final SessionInfo _info = SessionInfo.fromMap(_meta);
    final Prescription _pre = Prescription.fromMap(_meta);
    final List<ChartData> _dataList = List<Map<String, dynamic>>.from(export.value[Keys.KEY_USER_DATA] as List<dynamic>)
        .map<ChartData>((Map<String, dynamic> item) => ChartData.fromMap(item))
        .toList();

    return ListTile(
      key: ValueKey<String>(export.key),
      contentPadding: const EdgeInsets.all(5),
      subtitle: Text('Status: ${_info.dataStatus}'),
      leading: CustomAvatar(_info.typeAbbr, color: _info.color),
      title: Text(export.key, style: const TextStyle(fontSize: 18)),
      onTap: () {
        if (_dataList.isNotEmpty) {
          ItemClickController.sink?.add(ItemClickHandler(
            dataList: _dataList,
            sessionInfo: _info,
            prescription: _pre,
          ));
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
            child: ExpansionTile(
              title: Text('Delete'),
              leading: Icon(Icons.delete_rounded),
              children: <Widget>[ListTile(title: Text('Click to Delete!'))],
            ),
          ),
        ],
        onSelected: (ItemAction action) {
          switch (action) {
            case ItemAction.download:
              create(data: _dataList, sessionInfo: _info, prescription: _pre);
              break;
            case ItemAction.delete:
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
              break;
          }
        },
      ),
    );
  }
}
