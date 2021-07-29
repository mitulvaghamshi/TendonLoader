import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_graph.dart';
import 'package:tendon_loader/screens/livedata/livedata_handler.dart';
import 'package:tendon_loader/utils/themes.dart';

class LiveData extends StatelessWidget {
  const LiveData({Key? key}) : super(key: key);

  static const String name = 'Live Data';
  static const String route = '/liveData';

  @override
  Widget build(BuildContext context) {
    final LiveDataHandler _handler = LiveDataHandler(context: context);
    return CustomGraph(handler: _handler, builder: () => Text(_handler.elapsed, style: tsG40B));
  }
}
