import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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
  final List<ChartData> _dataList = <ChartData>[];
  final DataHandler _handler = DataHandler();
  double _lastMilliSec = 0;
  bool _isComplete = false;
  bool _isRunning = false;
  bool _hasData = false;
  DateTime _dateTime;
  double _lastMinLoad = 0;

  Future<void> _start() async {
    if (!_isRunning && _hasData) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Submit old data?'),
        action: SnackBarAction(
          label: 'Show Me!',
          onPressed: _backPress,
          textColor: Theme.of(context).primaryColor,
        ),
      ));
    } else if (!_isRunning && (await CountDown.start(context) ?? false)) {
      await Bluetooth.startWeightMeas();
      _dateTime = DateTime.now();
      _isComplete = false;
      _isRunning = true;
      _hasData = true;
    }
  }

  Future<void> _stop() async {
    await Bluetooth.stopWeightMeas();
    _lastMinLoad = 0;
  }

  void _reset() {
    if (_isRunning) {
      _isRunning = false;
      _stop();
      _lastMilliSec = 0;
      _handler.sink.add(ChartData());
      CustomGraph.updateLine(0);
    }
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
      onBackPressed: _backPress,
      child: Column(
        children: <Widget>[
          StreamBuilder<ChartData>(
            initialData: ChartData(),
            stream: _handler.stream,
            builder: (_, AsyncSnapshot<ChartData> snapshot) {
              if (_isRunning) {
                if (5 - snapshot.data.time == 0) {
                  _isRunning = false;
                  _isComplete = true;
                  _stop();
                } else if (snapshot.data.load > _lastMinLoad) {
                  CustomGraph.updateLine(_lastMinLoad = snapshot.data.load);
                }
              }
              CustomGraph.updateGraph(snapshot.data);
              return Column(
                children: <Widget>[
                  Text('MVC: ${_lastMinLoad.toStringAsFixed(2)} Kg', style: tsBold26),
                  const SizedBox(height: 16),
                  Text(snapshot.data.time.toRemaining, style: tsBold26.copyWith(color: Colors.red)),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          const CustomGraph(showLine: true),
          const SizedBox(height: 30),
          GraphControls(start: _start, reset: _reset),
        ],
      ),
    );
  }

  Future<bool> _backPress() async {
    _reset();
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
          _handler.sink.add(element);
          _dataList.add(element);
        }
      }
    }
  }
}
