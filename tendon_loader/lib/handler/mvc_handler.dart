import 'dart:async';

import 'package:api_server/api_server.dart';
import 'package:flutter/services.dart';
import 'package:tendon_loader/handler/graph_handler.dart';

class MVCHandler extends GraphHandler {
  MVCHandler({required this.mvcDuration, required super.onCountdown})
    : timeDiff = mvcDuration.toDouble(),
      super(lineData: [const ChartData(), const ChartData(time: 2)]);

  final int mvcDuration;

  double maxForce = 0;
  double timeDiff;

  @override
  Future<void> start() async {
    if (!isSessionRunning) {
      await (hasData ? exit : super.start)();
    }
  }

  @override
  Future<void> stop() async {
    if (isSessionRunning) {
      isSessionRunning = false;
      await super.stop();
      await exit();
      _reset();
    }
  }

  @override
  void update(ChartData data) {
    if (isSessionRunning) {
      timeDiff = mvcDuration - data.time;
      if (timeDiff == 0) {
        isComplete = true;
        unawaited(stop());
      } else if (data.load > maxForce) {
        maxForce = data.load;
        _updateLine();
        unawaited(HapticFeedback.vibrate());
      }
    }
  }

  @override
  Future<String> exit() async {
    if (!hasData) {
      return '';
    }
    export ??= const Exercise.empty().copyWith(mvcValue: maxForce);
    return super.exit();
  }

  @override
  void pause() {}
}

extension ExMVCHandler on MVCHandler {
  String get maxForceValue => 'MVC: ${maxForce.toStringAsFixed(2)} Kg';
  String get timeDiffValue => '🕒 ${timeDiff.abs().toStringAsFixed(1)} Sec';
}

extension on MVCHandler {
  void _updateLine() {
    lineData!.insertAll(0, [
      ChartData(load: maxForce),
      ChartData(time: 2, load: maxForce),
    ]);
    lineCtrl?.updateDataSource(updatedDataIndexes: [0, 1]);
  }

  void _reset() {
    maxForce = 0;
    timeDiff = mvcDuration.toDouble();
    _updateLine();
    GraphHandler.reset();
  }
}
