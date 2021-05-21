import 'dart:async';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/app/custom/confirm_dialod.dart';
import 'package:tendon_loader/app/custom/countdown.dart';
import 'package:tendon_loader/app/custom/custom_controls.dart';
import 'package:tendon_loader/app/custom/custom_graph.dart';
import 'package:tendon_loader/app/handler/bluetooth_handler.dart';
import 'package:tendon_loader/shared/common.dart';
import 'package:tendon_loader/shared/constants.dart';
import 'package:tendon_loader/shared/custom/custom_frame.dart';
import 'package:tendon_loader/shared/extensions.dart';
import 'package:tendon_loader/shared/handler/data_handler.dart';
import 'package:tendon_loader/shared/modal/chartdata.dart';
import 'package:tendon_loader/shared/modal/data_model.dart';
import 'package:tendon_loader/shared/modal/session_info.dart';

class BarGraph extends StatefulWidget {
  const BarGraph({Key? key}) : super(key: key);

  @override
  _BarGraphState createState() => _BarGraphState();
}

class _BarGraphState extends State<BarGraph> {
  final List<ChartData> _lineData = <ChartData>[const ChartData(), const ChartData(time: 2)];
  final List<ChartData?> _graphData = <ChartData?>[];
  final List<ChartData> _dataList = <ChartData>[];
  final DataHandler _handler = DataHandler();

  ChartSeriesController? _graphCtrl;
  late ChartSeriesController _lineCtrl;
  late DateTime _dateTime;

  bool _isComplete = false;
  bool _isRunning = false;
  bool _hasData = false;

  double _minTime = 0;
  double _minLoad = 0;

  Future<void> _start() async {
    if (!_isRunning && _hasData) {
      await _onExit();
    } else if (!_isRunning && (await CountDown.start(context) ?? false)) {
      await Bluetooth.startWeightMeas();
      _dateTime = DateTime.now();
      _isComplete = false;
      _isRunning = true;
      _hasData = true;
    }
  }

  void _stop() {
    _isRunning = false;
    Bluetooth.stopWeightMeas();
  }

  void _reset() {
    if (_isRunning) _stop();
    _minLoad = 0;
    _minTime = 0;
    _handler.clear();
    _graphData.insert(0, const ChartData());
    _graphCtrl!.updateDataSource(updatedDataIndex: 0);
    _lineData.insertAll(0, <ChartData>[const ChartData(load: 0), const ChartData(time: 2, load: 0)]);
    _lineCtrl.updateDataSource(updatedDataIndexes: <int>[0, 1]);
  }

  void _listener(List<int> data) {
    if (_isRunning && data.isNotEmpty && data[0] == Progressor.RES_WEIGHT_MEAS) {
      for (int x = 2; x < data.length; x += 8) {
        final double weight = data.getRange(x, x + 4).toList().toWeight;
        final double time = data.getRange(x + 4, x + 8).toList().toTime;
        if (time > _minTime) {
          _minTime = time;
          final ChartData element = ChartData(load: weight, time: time);
          _handler.sink.add(element);
          _dataList.add(element);
          if (5 - time == 0) {
            _isComplete = true;
            _stop();
          } else if (weight > _minLoad) {
            _minLoad = weight;
            _lineData.insertAll(0, <ChartData>[
              ChartData(load: _minLoad),
              ChartData(time: 2, load: _minLoad),
            ]);
            _lineCtrl.updateDataSource(updatedDataIndexes: <int>[0, 1]);
          }
        }
      }
    }
  }

  Future<bool> _onExit() async {
    _reset();
    if (!_hasData) return true;
    final bool? result = await ConfirmDialog.show(
      context,
      model: DataModel(
        dataList: _dataList,
        sessionInfo: SessionInfo(dateTime: _dateTime, dataStatus: _isComplete, exportType: Keys.KEY_PREFIX_MVC),
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
  void initState() {
    super.initState();
    Bluetooth.listen(_listener);
  }

  @override
  void dispose() {
    _reset();
    _handler.dispose();
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
            stream: _handler.stream,
            builder: (_, AsyncSnapshot<ChartData> snapshot) {
              _graphData.insert(0, snapshot.data);
              _graphCtrl?.updateDataSource(updatedDataIndex: 0);
              return Column(
                children: <Widget>[
                  Text('MVC: ${_minLoad.toStringAsFixed(2)} Kg', style: tsBold26),
                  const SizedBox(height: 16),
                  Text(snapshot.data!.time!.toRemaining, style: tsBold26.copyWith(color: Colors.red)),
                ],
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
