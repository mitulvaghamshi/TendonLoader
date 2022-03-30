import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tendon_loader/app/graph/graph_handler.dart';
import 'package:tendon_loader/shared/models/chartdata.dart';
import 'package:tendon_loader/shared/models/export.dart';
import 'package:tendon_loader/shared/utils/common.dart';

class MVCHandler extends GraphHandler {
  MVCHandler({required BuildContext context})
      : mvcDuration = settingsState.mvcDuration!,
        timeDiff = settingsState.mvcDuration!.toDouble(),
        super(
          context: context,
          lineData: <ChartData>[ChartData(), ChartData(time: 2)],
        );

  final int mvcDuration;
  double maxForce = 0;
  double timeDiff;

  String get maxForceValue => 'MVC: ${maxForce.toStringAsFixed(2)} Kg';
  String get timeDiffValue => '🕒 ${timeDiff.abs().toStringAsFixed(1)} Sec';

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
      if (isComplete) await congratulate();
      await exit();
      _clear();
    }
  }

  @override
  Future<bool> exit() async {
    if (!hasData) return true;
    export ??= Export(mvcValue: maxForce);
    return super.exit();
  }
}
