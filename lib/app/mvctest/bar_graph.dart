import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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
import 'package:tendon_loader/shared/modal/chartdata.dart';
import 'package:tendon_loader/shared/modal/data_handler.dart';
import 'package:tendon_loader/shared/modal/session_info.dart';

class BarGraph extends StatefulWidget {
  const BarGraph({Key key}) : super(key: key);

  @override
  _BarGraphState createState() => _BarGraphState();
}

class _BarGraphState extends State<BarGraph> {
  double _mvc = 0;
  DateTime _dateTime;
  bool _hasData = false;
  bool _isRunning = false;
  bool _isComplete = false;
  double _lastMilliSec = 0;
  ChartSeriesController _lineDataCtrl;
  ChartSeriesController _graphDataCtrl;
  final DataHandler _handler = DataHandler();
  final List<ChartData> _graphData = <ChartData>[ChartData()];
  final List<ChartData> _lineData = <ChartData>[ChartData(), ChartData(time: 2)];

  Future<void> _start() async {
    if (!_isRunning && _hasData) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Submit old data?'),
        action: SnackBarAction(label: 'Show Me!', onPressed: _backPressed, textColor: Theme.of(context).primaryColor),
      ));
    } else if (!_isRunning && (await CountDown.start(context) ?? false)) {
      await Bluetooth.startWeightMeas();
      _dateTime = DateTime.now();
      _isComplete = false;
      _isRunning = true;
      _hasData = true;
    }
  }

  Future<void> stop() async {
    await Bluetooth.stopWeightMeas();
    _mvc = 0;
    _lastMilliSec = 0;
    _isRunning = false;
    _graphData.insert(0, ChartData());
    _lineData.insertAll(0, <ChartData>[ChartData(), ChartData(time: 2)]);
  }

  void _reset() {
    if (_isRunning) stop();
    _handler.sink.add(ChartData());
    _graphDataCtrl.updateDataSource(updatedDataIndex: 0);
    _lineDataCtrl.updateDataSource(updatedDataIndexes: <int>[0, 1]);
  }

  @override
  void initState() {
    super.initState();
    Bluetooth.listen(_listener);
  }

  @override
  void dispose() {
    if (_isRunning) stop();
    _handler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppFrame(
      onBackPressed: _backPressed,
      child: Column(
        children: <Widget>[
          StreamBuilder<ChartData>(
            initialData: ChartData(),
            stream: _handler.stream,
            builder: (_, AsyncSnapshot<ChartData> snapshot) {
              if (_isRunning && 5 - snapshot.data.time == 0) {
                _isComplete = true;
                stop();
              }
              return Column(
                children: <Widget>[
                  Text('MVC: ${_mvc.toStringAsFixed(2)} Kg', style: tsBold26),
                  const SizedBox(height: 16),
                  Text(snapshot.data.time.toRemaining, style: tsBold26.copyWith(color: Colors.red)),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          CustomGraph(series: _getSeries),
          const SizedBox(height: 30),
          GraphControls(start: _start, reset: _reset),
        ],
      ),
    );
  }

  List<ChartSeries<ChartData, int>> _getSeries() {
    return <ChartSeries<ChartData, int>>[
      ColumnSeries<ChartData, int>(
        width: 0.9,
        borderWidth: 1,
        color: Colors.blue,
        animationDuration: 0,
        dataSource: _graphData,
        borderColor: Colors.black,
        xValueMapper: (ChartData data, _) => 1,
        yValueMapper: (ChartData data, _) => data.load,
        dataLabelSettings: DataLabelSettings(
          isVisible: true,
          showZeroValue: false,
          labelAlignment: ChartDataLabelAlignment.bottom,
          textStyle: TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),
        ),
        onRendererCreated: (ChartSeriesController controller) => _graphDataCtrl = controller,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
      ),
      LineSeries<ChartData, int>(
        width: 5,
        color: Colors.red,
        animationDuration: 0,
        dataSource: _lineData,
        yValueMapper: (ChartData data, _) => data.load,
        xValueMapper: (ChartData data, _) => data.time.toInt(),
        onRendererCreated: (ChartSeriesController controller) => _lineDataCtrl = controller,
      ),
    ];
  }

  Future<bool> _backPressed() async {
    if (_isRunning) await stop();
    if (!_hasData) return true;
    final bool result = await ConfirmDialog.export(
      context,
      sessionInfo: SessionInfo(
        dataStatus: _isComplete,
        exportType: Keys.KEY_PREFIX_MVC,
        dateTime: _dateTime,
        userId: (await Hive.openBox<Object>(Keys.KEY_LOGIN_BOX)).get(Keys.KEY_USERNAME) as String,
      ),
    );
    if (result == null) {
      return false;
    } else {
      _hasData = false;
    }
    return result;
  }

  void _listener(List<int> data) {
    if (_isRunning && data.isNotEmpty && data[0] == Progressor.RES_WEIGHT_MEAS) {
      for (int x = 2; x < data.length; x += 8) {
        final double weight = data.getRange(x, x + 4).toList().toWeight;
        final double time = data.getRange(x + 4, x + 8).toList().toTime;
        if (time > _lastMilliSec) {
          _lastMilliSec = time;
          final ChartData element = ChartData(load: weight, time: time);
          // ExportHandler.dataList.add(element);
          _handler.sink.add(element);
          _graphData.insert(0, element);
          _graphDataCtrl?.updateDataSource(updatedDataIndex: 0);
          if (weight > _mvc) {
            _mvc = weight;
            _lineData.insertAll(0, <ChartData>[ChartData(load: _mvc), ChartData(time: 2, load: _mvc)]);
            _lineDataCtrl?.updateDataSource(updatedDataIndexes: <int>[0, 1]);
          }
        }
      }
    }
  }
}
