import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/components/custom_button.dart';
import 'package:tendon_loader/components/custom_image.dart';
import 'package:tendon_loader/portal/panel.dart';
import 'package:tendon_loader/utils/controller/file_path.dart';
import 'package:tendon_loader/utils/modal/chart_data.dart';

import 'line_graph.dart';

class RightPanel extends StatelessWidget {
  const RightPanel({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Panel(
      child: StreamBuilder<DocumentReference>(
        stream: FilePath.stream,
        builder: (BuildContext context, AsyncSnapshot<DocumentReference> snapshot) {
          if (snapshot.hasData)
            return FutureBuilder<QuerySnapshot>(
              future: snapshot.data.collection('all_exports').get(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> exports) {
                if (exports.hasData) {
                  return Column(
                    children: exports.data.docs.map((QueryDocumentSnapshot dayExports) {
                      final Map<String, dynamic> timesExports = dayExports.data();
                      return Column(
                        children: timesExports.keys.map((String time) {
                          final Map<String, dynamic> export = timesExports[time] as Map<String, dynamic>;
                          final List<ChartData> data =
                              List<Map<String, dynamic>>.from(export['data'] as List<dynamic>).map<ChartData>((Map<String, dynamic> item) {
                            return ChartData(time: item['time'] as double, load: item['load'] as double);
                          }).toList();
                          return ListTile(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            contentPadding: const EdgeInsets.all(16),
                            title: Text(time, style: const TextStyle(fontSize: 16)),
                            leading: CircleAvatar(child: Text(time.contains('MVC') ? 'MVC' : 'EX')),
                            subtitle: Text(
                              'Status: ${export['isComplete'] as bool ? 'Complete' : 'Incomplete'}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                CustomButton(
                                  icon: Icons.visibility_rounded,
                                  withText: false,
                                  onPressed: () async {
                                    await showDialog<void>(
                                      context: context,
                                      useSafeArea: true,
                                      builder: (BuildContext context) => LineGraph(data: data),
                                    );
                                  },
                                ),
                                /*CustomButton(
                                  icon: Icons.visibility_rounded,
                                  withText: false,
                                  onPressed: () {
                                    //
                                  },
                                ),
                                CustomButton(
                                  icon: Icons.visibility_rounded,
                                  withText: false,
                                  onPressed: () {
                                    //
                                  },
                                ),
                                CustomButton(
                                  icon: Icons.visibility_rounded,
                                  withText: false,
                                  onPressed: () {
                                    //
                                  },
                                ),
                                CustomButton(
                                  icon: Icons.visibility_rounded,
                                  withText: false,
                                  onPressed: () {
                                    //
                                  },
                          ),*/
                              ],
                            ),
                            onTap: () {
                              //
                            },
                          );
                        }).toList(),
                      );
                    }).toList(),
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

/*
Text('Target load: ${export['targetLoad']}'),
Text('Hold time: ${export['holdTime']}'),
Text('Rest time: ${export['restTime']}'),
Text('Sets: ${export['sets']}'),
Text('Reps: ${export['reps']}'),
Text('Progressor ID: ${export['progressorId']}'),
*/
