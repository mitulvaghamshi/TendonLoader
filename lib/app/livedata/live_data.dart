import 'package:flutter/material.dart';
import 'package:tendon_loader/app/graph/graph_widget.dart';
import 'package:tendon_loader/app/livedata/livedata_handler.dart';

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
    return GraphWidget(
      handler: _handler,
      title: LiveData.name,
      builder: () => Text(
        _handler.elapsed,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 40,
          color: Color(0xff000000),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
