import 'package:flutter/material.dart';
import 'package:tendon_loader/constants/textstyles.dart';
import 'package:tendon_loader/custom/custom_graph.dart';
import 'package:tendon_loader/handlers/graph_handler.dart';
import 'package:tendon_loader/livedata/livedata_handler.dart';
import 'package:tendon_loader/modal/chartdata.dart';

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
    return Scaffold(
      appBar: AppBar(title: const Text(LiveData.name)),
      body: CustomGraph(
        handler: _handler,
        header: StreamBuilder<ChartData>(
          initialData: ChartData(),
          stream: GraphHandler.stream,
          builder: (_, AsyncSnapshot<ChartData> snapshot) {
            _handler.graphData.insert(0, snapshot.data!);
            _handler.graphCtrl?.updateDataSource(updatedDataIndex: 0);
            return FittedBox(child: Text(_handler.elapsed, style: tsG40B));
          },
        ),
      ),
    );
  }
}
