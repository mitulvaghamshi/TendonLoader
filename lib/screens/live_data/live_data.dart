import 'package:flutter/material.dart';
import 'package:tendon_loader/screens/live_data/bar_graph.dart';

class LiveData extends StatelessWidget {
  const LiveData({Key/*?*/ key}) : super(key: key);

  static const String name = 'Live Data';
  static const String route = '/liveData';

  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text(LiveData.name)), body: const BarGraph());
}
