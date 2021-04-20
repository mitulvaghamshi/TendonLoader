import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/components/custom_button.dart';
import 'package:tendon_loader/components/custom_image.dart';
import 'package:tendon_loader/portal/line_graph.dart';
import 'package:tendon_loader/portal/panel.dart';
import 'package:tendon_loader/utils/app/constants.dart';
import 'package:tendon_loader/utils/controller/file_path.dart';
import 'package:tendon_loader/utils/modal/chart_data.dart';

class RightPanel extends StatelessWidget {
  const RightPanel({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Panel(
      child: StreamBuilder<DocumentReference>(
        stream: FilePath.stream,
        builder: (BuildContext context, AsyncSnapshot<DocumentReference> user) {
          if (user.hasData)
            return FutureBuilder<QuerySnapshot>(
              future: user.data.collection(Keys.KEY_ALL_EXPORTS).get(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> allExports) {
                if (allExports.hasData) {
                  final List<QueryDocumentSnapshot> _dayList = allExports.data.docs;
                  return Expanded(
                    child: ListView.separated(
                      itemCount: _dayList.length,
                      separatorBuilder: (_, __) => Divider(color: Theme.of(context).accentColor),
                      itemBuilder: (_, int index) {
                        final Map<String, dynamic> _aDay = _dayList[index].data();
                        return Column(
                          children: _aDay.entries.map((MapEntry<String, dynamic> _time) {
                            final Map<String, dynamic> _metaData = _time.value[Keys.KEY_META_DATA] as Map<String, dynamic>;
                            return ListTile(
                              title: Text(_time.key, style: const TextStyle(fontSize: 16)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              subtitle: Text('Status: ${_metaData[Keys.KEY_DATA_STATUS]}', style: const TextStyle(fontSize: 12)),
                              leading: CircleAvatar(
                                backgroundColor: Theme.of(context).accentColor,
                                foregroundColor: Theme.of(context).primaryColor,
                                child: Text(_metaData[Keys.KEY_EXPORT_TYPE].toString().substring(0, 3)),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  CustomButton(
                                    withText: false,
                                    icon: Icons.visibility_rounded,
                                    onPressed: () async => showDialog<void>(
                                      context: context,
                                      useSafeArea: true,
                                      builder: (_) {
                                        final List<ChartData> _data =
                                            List<Map<String, dynamic>>.from(_time.value[Keys.KEY_USER_DATA] as List<dynamic>)
                                                .map<ChartData>((Map<String, dynamic> item) {
                                          return ChartData(time: item[Keys.KEY_CHART_Y] as double, load: item[Keys.KEY_CHART_X] as double);
                                        }).toList();
                                        return LineGraph(data: _data);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                //
                              },
                            );
                          }).toList(),
                        );
                      },
                    ),
                  );
                }
                return const Text('No data available!');
              },
            );
          return const CustomImage(isBg: true);
        },
      ),
    );
  }
}
