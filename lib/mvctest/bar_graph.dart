import 'dart:async' show Future;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/app_state/app_state_scope.dart';
import 'package:tendon_loader/utils/themes.dart';
import 'package:tendon_loader/custom/confirm_dialod.dart';
import 'package:tendon_loader/custom/countdown.dart';
import 'package:tendon_loader/custom/custom_controls.dart';
import 'package:tendon_loader/custom/custom_frame.dart';
import 'package:tendon_loader/custom/custom_graph.dart';
import 'package:tendon_loader/handler/bluetooth_handler.dart';
import 'package:tendon_loader/handler/clip_player.dart';
import 'package:tendon_loader/handler/dialog_handler.dart';
import 'package:tendon_loader/handler/graph_data_handler.dart';
import 'package:tendon_loader/modal/chartdata.dart';
import 'package:tendon_loader/modal/export.dart';

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
  late final int mvcDuration;
  late DateTime _dateTime;

  bool _isComplete = false;
  bool _isRunning = false;
  bool _hasData = false;

  double _mvcValue = 0;

  Future<void> _onStart() async {
    if (!_isRunning && _hasData) {
      await _onMVCTestClose();
    } else if (!_isRunning && (await CountDown.show(context) ?? false)) {
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

  void _onStop() {
    stopWeightMeasuring();
    _isRunning = false;
    play(false);
    Future<void>.delayed(const Duration(seconds: 1), _onMVCTestClose);
  }

  void _onReset() {
    if (_isRunning) _onStop();
    _graphData.insert(0, ChartData());
    _graphCtrl?.updateDataSource(updatedDataIndex: 0);
    _lineData.insertAll(0, <ChartData>[ChartData(), ChartData(time: 2)]);
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
      userId: AppStateScope.of(context).currentUser!.id,
    );

    final bool? result;
    if (AppStateScope.of(context).settingsState!.autoUpload!) {
      result = await submit(context, _export, false);
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    mvcDuration = AppStateScope.of(context).mvcDuration!;
  }

  @override
  void dispose() {
    _onReset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppFrame(
      onExit: _onMVCTestClose,
      child: Column(children: <Widget>[
        StreamBuilder<ChartData>(
          initialData: ChartData(),
          stream: graphDataStream,
          builder: (_, AsyncSnapshot<ChartData> snapshot) {
            if (mvcDuration - snapshot.data!.time! == 0) {
              _isComplete = true;
              if (_isRunning) _onStop();
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
              child: Column(children: <Widget>[
                Text(
                  'MVC: ${_mvcValue.toStringAsFixed(2)} Kg',
                  style: const TextStyle(color: googleGreen, fontSize: 36, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  '⏱ ${(mvcDuration - snapshot.data!.time!).toStringAsFixed(1)} Sec',
                  style: const TextStyle(color: red400, fontSize: 40, fontWeight: FontWeight.bold),
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
