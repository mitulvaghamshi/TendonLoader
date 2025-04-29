import 'package:flutter/services.dart';
import 'package:tendon_loader/handlers/graph_handler.dart';
import 'package:tendon_loader/models/chartdata.dart';
import 'package:tendon_loader/models/exercise.dart';

class MVCHandler extends GraphHandler {
  MVCHandler({required this.mvcDuration, required super.onCountdown})
    : timeDiff = mvcDuration.toDouble(),
      super(lineData: <ChartData>[const ChartData(), const ChartData(time: 2)]);

  final int mvcDuration;

  double maxForce = 0;
  double timeDiff;

  @override
  Future<void> start() async {
    if (!isRunning) await (hasData ? exit : super.start)();
  }

  @override
  Future<void> stop() async {
    if (isRunning) {
      isRunning = false;
      await super.stop();
      await exit();
      _clear();
    }
  }

  @override
  void update(ChartData data) {
    if (isRunning) {
      timeDiff = mvcDuration - data.time;
      if (timeDiff == 0) {
        isComplete = true;
        stop();
      } else if (data.load > maxForce) {
        maxForce = data.load;
        _updateLine();
        HapticFeedback.vibrate();
      }
    }
  }

  @override
  Future<String> exit() async {
    if (!hasData) return '';
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
    lineData!.insertAll(0, <ChartData>[
      ChartData(load: maxForce),
      ChartData(time: 2, load: maxForce),
    ]);
    lineCtrl?.updateDataSource(updatedDataIndexes: <int>[0, 1]);
  }

  void _clear() {
    maxForce = 0;
    timeDiff = mvcDuration.toDouble();
    _updateLine();
    GraphHandler.clear();
  }
}
