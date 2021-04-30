import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/shared/constants.dart';
import 'package:tendon_loader/shared/custom/custom_avater.dart';
import 'package:tendon_loader/shared/custom/custom_button.dart';
import 'package:tendon_loader/shared/custom/custom_image.dart';
import 'package:tendon_loader/shared/modal/chartdata.dart';
import 'package:tendon_loader/shared/modal/prescription.dart';
import 'package:tendon_loader/shared/modal/session_info.dart';
import 'package:tendon_loader/web/handler/create_excel.dart';
import 'package:tendon_loader/web/handler/user_reference.dart';
import 'package:tendon_loader/web/line_graph.dart';
import 'package:tendon_loader/web/panel/panel.dart';

class RightPanel extends StatelessWidget with CreateExcel {
  const RightPanel({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Panel(
      child: StreamBuilder<CollectionReference>(
        stream: UserReference.stream,
        builder: (_, AsyncSnapshot<CollectionReference> snapshot) {
          if (snapshot.hasData) {
            return FutureBuilder<QuerySnapshot>(
              future: snapshot.data.get(),
              builder: (_, AsyncSnapshot<QuerySnapshot> daysSnap) {
                if (daysSnap.hasData) {
                  return Expanded(
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: ListTile.divideTiles(
                        color: Theme.of(context).accentColor,
                        tiles: daysSnap.data.docs.map((QueryDocumentSnapshot daySnap) {
                          final Map<String, dynamic> exports = daySnap.data();
                          return ExpansionTile(
                            maintainState: true,
                            key: ValueKey<String>(daySnap.id),
                            tilePadding: const EdgeInsets.all(5),
                            leading: TextAvatar(daySnap.id.substring(8, 10)),
                            expandedCrossAxisAlignment: CrossAxisAlignment.start,
                            title: Text(daySnap.id, style: const TextStyle(fontSize: 18)),
                            subtitle: Text('${exports.length} export${exports.length == 1 ? '' : 's'} found.'),
                            children: ListTile.divideTiles(
                              color: Colors.deepOrange,
                              tiles: exports.entries.map((MapEntry<String, dynamic> _time) {
                                final SessionInfo _info =
                                    SessionInfo.fromMap(_time.value[Keys.KEY_META_DATA] as Map<String, dynamic>);
                                final bool _isMVC = _info.exportType.contains('MVC');
                                return ListTile(
                                  hoverColor: Colors.blue,
                                  key: ValueKey<String>(_time.key),
                                  contentPadding: const EdgeInsets.all(5),
                                  subtitle: Text('Status: ${_info.dataStatus}'),
                                  title: Text(_time.key, style: const TextStyle(fontSize: 18)),
                                  leading: TextAvatar(
                                    _info.exportType.substring(0, 3),
                                    color: _isMVC ? Colors.green : Colors.orange,
                                  ),
                                  onTap: () {},
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      CustomButton(
                                        withText: false,
                                        icon: Icons.visibility_rounded,
                                        onPressed: () async => showDialog<void>(
                                          context: context,
                                          useSafeArea: true,
                                          builder: (_) => LineGraph(
                                            info: _info,
                                            name: _getName(_info),
                                            data: _getDataList(_time),
                                            prescription: _getPrescription(_isMVC, _time),
                                          ),
                                        ),
                                      ),
                                      CustomButton(
                                        withText: false,
                                        icon: Icons.download_rounded,
                                        onPressed: () => create(
                                          sessionInfo: _info,
                                          data: _getDataList(_time),
                                          prescription: _getPrescription(_isMVC, _time),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ).toList(),
                          );
                        }),
                      ).toList(),
                    ),
                  );
                }
                return const Text('No data available!');
              },
            );
          }
          return const Expanded(child: CustomImage(isLogo: true));
        },
      ),
    );
  }

  String _getName(SessionInfo _info) =>
      '${_info.exportDate}_${_info.exportTime}_${_info.userId}_${_info.exportType}.xlsx';

  Prescription _getPrescription(bool _isMVC, MapEntry<String, dynamic> _time) {
    return _isMVC ? null : Prescription.fromMap(_time.value[Keys.KEY_META_DATA] as Map<String, dynamic>);
  }

  List<ChartData> _getDataList(MapEntry<String, dynamic> _time) {
    return List<Map<String, dynamic>>.from(_time.value[Keys.KEY_USER_DATA] as List<dynamic>)
        .map<ChartData>((Map<String, dynamic> item) {
      return ChartData(time: item[Keys.KEY_CHART_Y] as double, load: item[Keys.KEY_CHART_X] as double);
    }).toList();
  }
}
