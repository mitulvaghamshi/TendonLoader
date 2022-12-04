import 'package:flutter/services.dart';
import 'package:tendon_loader/common/models/chartdata.dart';
import 'package:tendon_loader/common/models/export.dart';
import 'package:tendon_loader/screens/graph/models/graph_handler.dart';

class MVCHandler extends GraphHandler {
  MVCHandler({required super.context, required this.mvcDuration})
      : timeDiff = mvcDuration.toDouble(),
        super(lineData: <ChartData>[ChartData(), ChartData(time: 2)]);

  final int mvcDuration;

  double maxForce = 0;
  double timeDiff;

  @override
  Future<void> start() async {
    if (!isRunning) {
      hasData ? await exit() : await super.start();
    }
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
    export ??= Export(mvcValue: maxForce);
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
