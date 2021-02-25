import 'package:flutter/material.dart';
import 'package:tendon_loader/utils/bar_graph.dart';

class LiveData extends StatelessWidget {
  static const name = 'Live Data';
  static const routeName = '/liveData';

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text(LiveData.name)), body: const BarGraph(isLiveData: true));
  }
}
