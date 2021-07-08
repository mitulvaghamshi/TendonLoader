import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/custom/custom_controls.dart';
import 'package:tendon_loader/custom/custom_frame.dart';
import 'package:tendon_loader/custom/custom_graph.dart';
import 'package:tendon_loader/handler/device_handler.dart';
import 'package:tendon_loader/handler/dialog_handler.dart';
import 'package:tendon_loader/handler/graph_data_handler.dart';
import 'package:tendon_loader/modal/chartdata.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/utils/clip_player.dart';
import 'package:tendon_loader/utils/themes.dart';

class BarGraph extends StatefulWidget {
  const BarGraph({Key? key}) : super(key: key);

  @override
  _BarGraphState createState() => _BarGraphState();
}

class _BarGraphState extends State<BarGraph> {
  final List<ChartData> _lineData = <ChartData>[ChartData(), ChartData(time: 2)];
  final List<ChartData> _graphData = <ChartData>[];
  ChartSeriesController? _graphCtrl;
  ChartSeriesController? _lineCtrl;
  late Timestamp? _timestamp;
  late final int mvcDuration;
  bool _isComplete = false;
  bool _isRunning = false;
  bool _hasData = false;
  double _maxForce = 0;

  Future<void> _onStart() async {
    if (!_isRunning && _hasData) {
      await _onExit();
    } else if (!_isRunning && (await startCountdown(context) ?? false)) {
      _timestamp = Timestamp.now();
      _isComplete = false;
      _isRunning = true;
      _hasData = true;
      _maxForce = 0;
      play(true);
      exportDataList.clear();
      await startWeightMeas();
    }
  }

  Future<void> _onStop() async {
    _isRunning = false;
    play(false);
    await stopWeightMeas();
    if (_hasData) await Future<void>.microtask(_onExit);
  }

  Future<void> _onReset() async {
    if (_isRunning) await _onStop();
    _graphData.insert(0, ChartData());
    _graphCtrl?.updateDataSource(updatedDataIndex: 0);
    _lineData.insertAll(0, <ChartData>[ChartData(), ChartData(time: 2)]);
    _lineCtrl?.updateDataSource(updatedDataIndexes: <int>[0, 1]);
  }

  Future<bool> _onExit() async {
    if (!_hasData) return true;
    final Export _export = Export(
      mvcValue: _maxForce,
      timestamp: _timestamp!,
      isComplate: _isComplete,
      progressorId: deviceName,
      exportData: exportDataList,
      userId: context.model.currentUser!.id,
    );
    if (_isRunning) {
      await stopWeightMeas();
      return submitData(context, _export, false);
    }
    final bool? result;
    if (context.model.settingsState!.autoUpload!) {
      result = await submitData(context, _export, false);
    } else {
      result = await confirmSubmit(context, _export);
    }
    if (result == null) {
      return false;
    } else {
      _hasData = false;
    }
    return result;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    mvcDuration = context.model.mvcDuration!;
  }

  @override
  void dispose() {
    _onReset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppFrame(
      onExit: _onExit,
      child: Column(children: <Widget>[
        StreamBuilder<ChartData>(
          initialData: ChartData(),
          stream: graphDataStream,
          builder: (_, AsyncSnapshot<ChartData> snapshot) {
            if (mvcDuration - snapshot.data!.time! == 0) {
              _isComplete = true;
              if (_isRunning) _onStop();
            } else if (snapshot.data!.load! > _maxForce) {
              _maxForce = snapshot.data!.load!;
              _lineData.insertAll(0, <ChartData>[
                ChartData(load: _maxForce),
                ChartData(time: 2, load: _maxForce),
              ]);
              _lineCtrl?.updateDataSource(updatedDataIndexes: <int>[0, 1]);
            }
            _graphData.insert(0, snapshot.data!);
            _graphCtrl?.updateDataSource(updatedDataIndex: 0);
            return FittedBox(
              fit: BoxFit.fitWidth,
              child: Column(children: <Widget>[
                Text(
                  'MVC: ${_maxForce.toStringAsFixed(2)} Kg',
                  style: const TextStyle(color: colorGoogleGreen, fontSize: 36, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  '⏱ ${(mvcDuration - snapshot.data!.time!).toStringAsFixed(1)} Sec',
                  style: const TextStyle(color: colorRed400, fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ]),
            );
          },
        ),
        CustomGraph(
          lineData: _lineData,
          graphData: _graphData,
          lineCtrl: (ChartSeriesController ctrl) => _lineCtrl = ctrl,
          graphCtrl: (ChartSeriesController ctrl) => _graphCtrl = ctrl,
        ),
        GraphControls(start: _onStart, reset: _onReset),
      ]),
    );
  }
}
