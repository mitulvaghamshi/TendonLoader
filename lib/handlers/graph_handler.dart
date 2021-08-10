import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/subjects.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/handlers/audio_handler.dart';
import 'package:tendon_loader/handlers/device_handler.dart';
import 'package:tendon_loader/handlers/dialogs_handler.dart';
import 'package:tendon_loader/main.dart';
import 'package:tendon_loader/modal/chartdata.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/progressor.dart';
import 'package:tendon_loader/utils/themes.dart';

// Simuation block start
late Timer? _timer;
late bool isSumulation = false;

void _fakeStart() {
  double _fakeLoad = 0;
  double _fakeTime = 0;
  bool _up = true;
  _timer = Timer.periodic(const Duration(milliseconds: 100), (Timer timer) {
    if (!isPause) {
      final ChartData element = ChartData(load: _fakeLoad.abs(), time: _fakeTime);
      GraphHandler.exportData.add(element);
      GraphHandler.sink.add(element);
      if (timer.tick % 10 == 0) _fakeTime = timer.tick / 10;
      if (_up) {
        _fakeLoad += .100;
        if (_fakeLoad >= 8) _up = false;
      } else {
        _fakeLoad -= .100;
        if (_fakeLoad <= 0) _up = true;
      }
    }
  });
}
// Simulation block end

bool isPause = false;

class GraphHandler {
  GraphHandler({required this.context, this.lineData}) : userId = context.model.currentUser!.id {
    isRunning = isComplete = hasData = false;
    stream.listen(update);
    clear();
  }

  bool isHit = false;

  late bool hasData;
  final String userId;
  late bool isRunning;
  late bool isComplete;
  late Timestamp timestamp;

  final BuildContext context;

  List<ChartData>? lineData;
  ChartSeriesController? lineCtrl;
  ChartSeriesController? graphCtrl;
  final List<ChartData> graphData = <ChartData>[];

  @protected
  Export? export;
  @protected
  static final List<ChartData> exportData = <ChartData>[];

  static final BehaviorSubject<ChartData> _controller = BehaviorSubject<ChartData>.seeded(ChartData());
  static Stream<ChartData> get stream => _controller.stream;
  static Sink<ChartData> get sink => _controller.sink; // simulation

  Color get feedColor => isHit ? colorGoogleGreen : colorWhite;

  static void clear() {
    _lastMillis = 0;
    _controller.sink.add(ChartData());
  }

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
      await HapticFeedback.heavyImpact();
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
    if (!hasData) return true;
    if (!export!.isInBox) {
      export!
        ..userId = userId
        ..timestamp = timestamp
        ..isComplate = isComplete
        ..progressorId = deviceName
        ..exportData = exportData;
      await boxExport.add(export!);
    }
    if (isRunning) await stop();

    export!.painScore ??= await selectPain(context);
    export!.isTolerable ??= await selectTolerance(context);
    await export!.save();

    if (export!.painScore == null || export!.isTolerable == null) return false;

    final bool? result = await submitData(context, export!);
    if (result == null) {
      return false;
    } else if (result) {
      hasData = false;
      export = null;
    }
    isPause = false;
    return result;
  }
}
