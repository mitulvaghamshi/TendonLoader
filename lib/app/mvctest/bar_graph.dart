import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tendon_loader/app/custom/confirm_dialod.dart';
import 'package:tendon_loader/app/custom/countdown.dart';
import 'package:tendon_loader/app/custom/custom_controls.dart';
import 'package:tendon_loader/app/custom/custom_graph.dart';
import 'package:tendon_loader/app/handler/data_handler.dart';
import 'package:tendon_loader/shared/common.dart';
import 'package:tendon_loader/shared/constants.dart';
import 'package:tendon_loader/shared/custom/custom_frame.dart';
import 'package:tendon_loader/shared/extensions.dart';
import 'package:tendon_loader/shared/modal/chartdata.dart';
import 'package:tendon_loader/shared/modal/session_info.dart';

class BarGraph extends StatefulWidget {
  const BarGraph({Key key}) : super(key: key);

  @override
  _BarGraphState createState() => _BarGraphState();
}

class _BarGraphState extends State<BarGraph> {
  final DataHandler _handler = DataHandler();
  bool _isComplete = false;
  bool _isRunning = false;
  bool _hasData = false;
  DateTime _dateTime;
  double _mvc = 0;

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
      await _handler.start();
      _dateTime = DateTime.now();
      _isComplete = false;
      _isRunning = true;
      _hasData = true;
    }
  }

  Future<void> _stop() async {
    await _handler.reset();
    _mvc = 0;
  }

  void _reset() {
    if (_isRunning) {
      _stop();
      _isRunning = false;
      CustomGraph.updateLine(0);
      CustomGraph.updateGraph(ChartData());
    }
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
          StreamBuilder<dynamic>(
            initialData: ChartData(),
            stream: _handler.stream,
            builder: (_, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.data is SendPort) _handler.listen(snapshot.data);
              final ChartData data = snapshot.data as ChartData;
              CustomGraph.updateGraph(data);
              if (_isRunning && 5 - data.time == 0) {
                _isComplete = true;
                _stop();
              } else if (data.load > _mvc) {
                CustomGraph.updateLine(_mvc = data.load);
              }
              return Column(
                children: <Widget>[
                  Text('MVC: ${_mvc.toStringAsFixed(2)} Kg', style: tsBold26),
                  const SizedBox(height: 16),
                  Text(data.time.toRemaining, style: tsBold26.copyWith(color: Colors.red)),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          const CustomGraph(),
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

  // void _listener(List<int> data) {
  //   if (_isRunning && data.isNotEmpty && data[0] == Progressor.RES_WEIGHT_MEAS) {
  //     for (int x = 2; x < data.length; x += 8) {
  //       final double weight = data.getRange(x, x + 4).toList().toWeight;
  //       final double time = data.getRange(x + 4, x + 8).toList().toTime;
  //       if (time > _lastMilliSec) {
  //         _lastMilliSec = time;
  //         final ChartData element = ChartData(load: weight, time: time);
  //         // ExportHandler.dataList.add(element);
  //         _handler.sink.add(element);
  //         _graphData.insert(0, element);
  //         _graphDataCtrl?.updateDataSource(updatedDataIndex: 0);
  //         if (weight > _mvc) {
  //           _mvc = weight;
  //           _lineData.insertAll(0, <ChartData>[ChartData(load: _mvc), ChartData(time: 2, load: _mvc)]);
  //           _lineDataCtrl?.updateDataSource(updatedDataIndexes: <int>[0, 1]);
  //         }
  //       }
  //     }
  //   }
  // }
}
