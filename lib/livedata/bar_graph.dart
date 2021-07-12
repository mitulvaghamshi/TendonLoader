import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_controls.dart';
import 'package:tendon_loader/custom/custom_frame.dart';
import 'package:tendon_loader/custom/custom_graph.dart';
import 'package:tendon_loader/device/handler/device_handler.dart';
import 'package:tendon_loader/exercise/graph_handler.dart';
import 'package:tendon_loader/modal/chartdata.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/themes.dart';

class BarGraph extends StatefulWidget {
  const BarGraph({Key? key}) : super(key: key);

  @override
  _BarGraphState createState() => _BarGraphState();
}

class _BarGraphState extends State<BarGraph> {
  late final GraphHandler _handler = GraphHandler(context: context);

  @override
  Widget build(BuildContext context) {
    return AppFrame(
      onExit: _handler.exit,
      child: Column(
        children: <Widget>[
          StreamBuilder<ChartData>(
            initialData: ChartData(),
            stream: graphDataStream,
            builder: (_, AsyncSnapshot<ChartData> snapshot) {
              _handler.graphData.insert(0, snapshot.data!);
              _handler.graphCtrl?.updateDataSource(updatedDataIndex: 0);
              return FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  snapshot.data!.time.toTime,
                  style: const TextStyle(color: colorGoogleGreen, fontSize: 40, fontWeight: FontWeight.bold),
                ),
              );
            },
          ),
          CustomGraph(handler: _handler),
          GraphControls(start: _handler.start, reset: _handler.reset),
        ],
      ),
    );
  }
}
