import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_graph.dart';
import 'package:tendon_loader/screens/livedata/livedata_handler.dart';
import 'package:tendon_loader/utils/themes.dart';

class LiveData extends StatefulWidget {
  const LiveData({Key? key}) : super(key: key);

  static const String name = 'Live Data';
  static const String route = '/liveData';

  @override
  _LiveDataState createState() => _LiveDataState();
}

class _LiveDataState extends State<LiveData> {
  late final LiveDataHandler _handler = LiveDataHandler(context: context);

  @override
  Widget build(BuildContext context) {
    return CustomGraph(
      handler: _handler,
      title: LiveData.name,
      builder: () => Text(_handler.elapsed, style: tsG40B),
    );
  }
}
