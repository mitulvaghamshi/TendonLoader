import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/constants/progressor.dart';
import 'package:tendon_loader/handlers/device_handler.dart';
import 'package:tendon_loader/modal/chartdata.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/utils/clip_player.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/helper.dart';

class GraphHandler {
  GraphHandler({required this.context, this.lineData}) : userId = context.model.currentUser!.id {
    isRunning = isComplete = hasData = false;
    stream.listen(update);
  }

  @protected
  Export? export;
  late bool hasData;
  final String userId;
  late bool isRunning;
  late bool isComplete;
  late Timestamp timestamp;
  List<ChartData>? lineData;
  final BuildContext context;
  ChartSeriesController? lineCtrl;
  ChartSeriesController? graphCtrl;
  final List<ChartData> graphData = <ChartData>[];
  @protected
  static final List<ChartData> exportData = <ChartData>[];

  static final BehaviorSubject<ChartData> _controller = BehaviorSubject<ChartData>.seeded(ChartData());
  static Stream<ChartData> get stream => _controller.stream;
  static Sink<ChartData> get sink => _controller.sink; // simulation

  static void disposeGraphData() {
    if (!_controller.isClosed) _controller.close();
  }

  static double _lastMillis = 0;
  static void onData(List<int> data) {
    if (!isPause && data.isNotEmpty && data[0] == resWeightMeasurement) {
      for (int x = 2; x < data.length; x += 8) {
        final double weight = data.getRange(x, x + 4).toList().toWeight;
        final double time = data.getRange(x + 4, x + 8).toList().toTime;
        if (time > _lastMillis) {
          _lastMillis = time;
          final ChartData element = ChartData(load: weight, time: time);
          exportData.add(element);
          _controller.sink.add(element);
        }
      }
    }
  }

  @mustCallSuper
  Future<void> start() async {
    if (await startCountdown(context) ?? false) {
      play(true);
      hasData = true;
      isRunning = true;
      isComplete = false;
      exportData.clear();
      timestamp = Timestamp.now();
      //
      if (isSumulation) {
        _fakeStart();
      } else {
        await startWeightMeas();
      }
      //
    }
  }

  void pause() {}

  void update(ChartData data) {}

  @mustCallSuper
  Future<void> stop() async {
    //
    if (isSumulation) {
      _timer?.cancel();
    } else {
      await stopWeightMeas();
    }
    //
    play(false);
  }

  @mustCallSuper
  Future<bool> exit() async {
    if (isRunning || !hasData) return stop().then((_) => true);
    final bool? result = await submitData(context, export!);
    if (result == null) {
      return false;
    } else if (result) {
      hasData = false;
      export = null;
      exportData.clear();
      _controller.sink.add(ChartData());
    }
    return result;
  }
}

// Simuation block start
late Timer? _timer;
late bool isSumulation;

void _fakeStart() {
  double _fakeLoad = 0;
  _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
    if (!isPause) {
      final ChartData element = ChartData(load: _fakeLoad, time: timer.tick.toDouble());
      GraphHandler.exportData.add(element);
      GraphHandler.sink.add(element);
      _fakeLoad = _fakeLoad > 15 ? 0 : _fakeLoad + .5;
    }
  });
}
// Simulation block end
