import 'dart:async' show Future;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/app_state/app_state_scope.dart';
import 'package:tendon_loader/app_state/export.dart';
import 'package:tendon_loader/custom/confirm_dialod.dart';
import 'package:tendon_loader/custom/countdown.dart';
import 'package:tendon_loader/custom/custom_controls.dart';
import 'package:tendon_loader/custom/custom_frame.dart';
import 'package:tendon_loader/custom/custom_graph.dart';
import 'package:tendon_loader/handler/bluetooth_handler.dart';
import 'package:tendon_loader/handler/clip_player.dart';
import 'package:tendon_loader/handler/export_handler.dart';
import 'package:tendon_loader/handler/graph_data_handler.dart';
import 'package:tendon_loader/modal/chartdata.dart'; 

class BarGraph extends StatefulWidget {
  const BarGraph({Key? key, required this.duration}) : super(key: key);

  final int duration;

  @override
  _BarGraphState createState() => _BarGraphState();
}

class _BarGraphState extends State<BarGraph> {
  final List<ChartData> _lineData = <ChartData>[const ChartData(), const ChartData(time: 2)];
  final List<ChartData> _graphData = <ChartData>[];

  ChartSeriesController? _graphCtrl;
  ChartSeriesController? _lineCtrl;
  late DateTime _dateTime;

  bool _isComplete = false;
  bool _isRunning = false;
  bool _hasData = false;

  double _mvcValue = 0;

  Future<void> _start() async {
    if (!_isRunning && _hasData) {
      await _onMVCTestClose();
    } else if (!_isRunning && (await CountDown.start(context) ?? false)) {
      _dateTime = DateTime.now();
      _isComplete = false;
      _isRunning = true;
      _hasData = true;
      _mvcValue = 0;
      play(true);
      exportDataList.clear();
      await startWeightMeasuring();
    }
  }

  void _stop() {
    stopWeightMeasuring();
    _isRunning = false;
    play(false);
    Future<void>.delayed(const Duration(seconds: 1), _onMVCTestClose);
  }

  void _reset() {
    if (_isRunning) _stop();
    _graphData.insert(0, const ChartData());
    _graphCtrl?.updateDataSource(updatedDataIndex: 0);
    _lineData.insertAll(0, <ChartData>[const ChartData(), const ChartData(time: 2)]);
    _lineCtrl?.updateDataSource(updatedDataIndexes: <int>[0, 1]);
  }

  Future<bool> _onMVCTestClose() async {
    if (!_hasData) return true;
    final Export _export = Export(
      mvcValue: _mvcValue,
      isComplate: _isComplete,
      progressorId: deviceName,
      exportData: exportDataList,
      timestamp: Timestamp.fromDate(_dateTime),
      userId: AppStateScope.of(context).userId,
    );

    final bool? result;
    if (AppStateScope.of(context).autoUpload!) {
      result = await submit(_export, false);
      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Data stored successfully...'),
        ));
      }
    } else {
      result = await ConfirmDialog.show(context, export: _export);
    }
    if (result == null) {
      return false;
    } else {
      _hasData = false;
    }
    return result;
  }

  @override
  void dispose() {
    _reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppFrame(
      onExit: _onMVCTestClose,
      child: Column(
        children: <Widget>[
          StreamBuilder<ChartData>(
            initialData: const ChartData(),
            stream: graphDataStream,
            builder: (_, AsyncSnapshot<ChartData> snapshot) {
              if (widget.duration - snapshot.data!.time! == 0) {
                _isComplete = true;
                if (_isRunning) _stop();
              } else if (snapshot.data!.load! > _mvcValue) {
                _mvcValue = snapshot.data!.load!;
                _lineData.insertAll(0, <ChartData>[
                  ChartData(load: _mvcValue),
                  ChartData(time: 2, load: _mvcValue),
                ]);
                _lineCtrl?.updateDataSource(updatedDataIndexes: <int>[0, 1]);
              }
              _graphData.insert(0, snapshot.data!);
              _graphCtrl?.updateDataSource(updatedDataIndex: 0);
              return FittedBox(
                fit: BoxFit.fitWidth,
                child: Column(
                  children: <Widget>[
                    Text(
                      'MVC: ${_mvcValue.toStringAsFixed(2)} Kg',
                      style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '⏱ ${(widget.duration - snapshot.data!.time!).toStringAsFixed(1)} Sec',
                      style: const TextStyle(color: Colors.deepOrange, fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            },
          ),
          CustomGraph(
            lineData: _lineData,
            graphData: _graphData,
            lineCtrl: (ChartSeriesController ctrl) => _lineCtrl = ctrl,
            graphCtrl: (ChartSeriesController ctrl) => _graphCtrl = ctrl,
          ),
          GraphControls(start: _start, reset: _reset),
        ],
      ),
    );
  }
}
