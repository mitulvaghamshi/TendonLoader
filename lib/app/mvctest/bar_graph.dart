import 'dart:async';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/app/custom/confirm_dialod.dart';
import 'package:tendon_loader/app/custom/countdown.dart';
import 'package:tendon_loader/app/custom/custom_controls.dart';
import 'package:tendon_loader/app/custom/custom_graph.dart';
import 'package:tendon_loader/app/handler/bluetooth_handler.dart';
import 'package:tendon_loader/app/handler/data_handler.dart';
import 'package:tendon_loader/shared/constants.dart';
import 'package:tendon_loader/shared/custom/custom_frame.dart';
import 'package:tendon_loader/shared/extensions.dart';
import 'package:tendon_loader/shared/modal/chartdata.dart';
import 'package:tendon_loader/shared/modal/data_model.dart';
import 'package:tendon_loader/shared/modal/session_info.dart';

class BarGraph extends StatefulWidget {
  const BarGraph({Key? key}) : super(key: key);

  @override
  _BarGraphState createState() => _BarGraphState();
}

class _BarGraphState extends State<BarGraph> with DataHandler {
  final List<ChartData> _lineData = <ChartData>[const ChartData(), const ChartData(time: 2)];
  final List<ChartData> _graphData = <ChartData>[];

  ChartSeriesController? _graphCtrl;
  ChartSeriesController? _lineCtrl;
  late DateTime _dateTime;

  bool _isComplete = false;
  bool _isRunning = false;
  bool _hasData = false;

  double _minLoad = 0;

  Future<void> _start() async {
    if (!_isRunning && _hasData) {
      await _onExit();
    } else if (!_isRunning && (await CountDown.start(context) ?? false)) {
      await Bluetooth.startWeightMeas();
      Bluetooth.dataList.clear();
      KPlayer.playStart();
      _dateTime = DateTime.now();
      _isComplete = false;
      _isRunning = true;
      _hasData = true;
    }
  }

  void _stop() {
    _isRunning = false;
    KPlayer.playStop();
    Bluetooth.stopWeightMeas();
    Future<void>.delayed(const Duration(seconds: 1), _onExit);
  }

  void _reset() {
    if (_isRunning) _stop();
    _minLoad = 0;
    DataHandler.dataClear();
    _graphData.insert(0, const ChartData());
    _graphCtrl?.updateDataSource(updatedDataIndex: 0);
    _lineData.insertAll(0, <ChartData>[const ChartData(), const ChartData(time: 2)]);
    _lineCtrl?.updateDataSource(updatedDataIndexes: <int>[0, 1]);
  }

  Future<bool> _onExit() async {
    if (!_hasData) return true;
    final bool? result = await ConfirmDialog.show(
      context,
      model: DataModel(
        dataList: Bluetooth.dataList,
        sessionInfo: SessionInfo(
          dateTime: _dateTime,
          dataStatus: _isComplete,
          exportType: Keys.KEY_PREFIX_MVC,
        ),
      ),
    );
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
      onExit: _onExit,
      child: Column(
        children: <Widget>[
          StreamBuilder<ChartData>(
            initialData: const ChartData(),
            stream: dataStream,
            builder: (_, AsyncSnapshot<ChartData> snapshot) {
              if (5 - snapshot.data!.time! == 0) {
                _isComplete = true;
                _stop();
              } else if (snapshot.data!.load! > _minLoad) {
                _minLoad = snapshot.data!.load!;
                _lineData.insertAll(0, <ChartData>[
                  ChartData(load: _minLoad),
                  ChartData(time: 2, load: _minLoad),
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
                      'MVC: ${_minLoad.toStringAsFixed(2)} Kg',
                      style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      snapshot.data!.time!.toRemaining,
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
