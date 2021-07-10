import 'dart:async';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/custom/custom_controls.dart';
import 'package:tendon_loader/custom/custom_frame.dart';
import 'package:tendon_loader/custom/custom_graph.dart';
import 'package:tendon_loader/device/handler/device_handler.dart';
import 'package:tendon_loader/exercise/progress_handler.dart';
import 'package:tendon_loader/modal/chartdata.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/helper.dart';
import 'package:tendon_loader/utils/initializer.dart';
import 'package:tendon_loader/utils/themes.dart';

class BarGraph extends StatefulWidget {
  const BarGraph({Key? key}) : super(key: key);

  @override
  _BarGraphState createState() => _BarGraphState();
}

class _BarGraphState extends State<BarGraph> {
  ChartSeriesController? _graphCtrl;
  final List<ChartData> _graphData = <ChartData>[];
  late final ProgressHandler _handler = ProgressHandler(onExit: _onExit, context: context);
  Export? _export;

  Future<bool> _onExit() async {
    if (!_handler.hasData) return true;
    if (_export == null) {
      _export = Export(
        progressorId: deviceName,
        prescription: _handler.pre,
        exportData: exportDataList,
        timestamp: _handler.timestamp,
        isComplate: _handler.isComplete,
        userId: context.model.currentUser!.id,
      );
      await boxExport.add(_export!);
    }
    if (_handler.isRunning) return stopWeightMeas().then((_) => true);
    final bool result = await submitData(context, _export!) ?? true;
    if (result) {
      _handler.hasData = false;
      _export = null;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return AppFrame(
      onExit: _onExit,
      child: Column(children: <Widget>[
        StreamBuilder<ChartData>(
          stream: graphDataStream,
          initialData: ChartData(),
          builder: (_, AsyncSnapshot<ChartData> snapshot) {
            _graphData.insert(0, snapshot.data!);
            _graphCtrl?.updateDataSource(updatedDataIndex: 0);
            _handler.update(snapshot.data!.time!.truncate());
            return FittedBox(
              fit: BoxFit.fitWidth,
              child: Column(children: <Widget>[
                Text(
                  _handler.lapTime,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: _handler.isHold ? colorGoogleGreen : colorRed400,
                  ),
                ),
                const SizedBox(height: 10),
                Chip(
                  padding: const EdgeInsets.all(16),
                  label: Text(
                    _handler.progress,
                    style: const TextStyle(color: Colors.black, fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor:
                      snapshot.data!.load! > _handler.pre.targetLoad ? colorGoogleGreen : colorGoogleYellow,
                ),
              ]),
            );
          },
        ),
        CustomGraph(
          graphData: _graphData,
          graphCtrl: (ChartSeriesController ctrl) => _graphCtrl = ctrl,
          lineData: <ChartData>[
            ChartData(load: _handler.pre.targetLoad),
            ChartData(time: 2, load: _handler.pre.targetLoad),
          ],
        ),
        GraphControls(stop: _handler.stop, start: _handler.start, reset: _handler.reset),
      ]),
    );
  }
}
