import 'package:flutter/material.dart';
import 'package:tendon_loader/handlers/device_handler.dart';
import 'package:tendon_loader/handlers/graph_handler.dart';
import 'package:tendon_loader/modal/chartdata.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/helper.dart';
import 'package:tendon_loader/utils/initializer.dart';

class MVCHandler extends GraphHandler {
  MVCHandler({required BuildContext context})
      : mvcDuration = context.model.mvcDuration!,
        timeDiff = context.model.mvcDuration!.toDouble(),
        super(context: context, lineData: <ChartData>[ChartData(), ChartData(time: 2)]);

  final int mvcDuration;
  double maxForce = 0;
  double timeDiff;

  String get maxForceValue => 'MVC: $maxForce Kg';
  String get timeDiffValue => '🕒 ${timeDiff.abs().toStringAsFixed(1)} Sec';

  void _updateLine() {
    lineData!.insertAll(0, <ChartData>[
      ChartData(load: maxForce),
      ChartData(time: 2, load: maxForce),
    ]);
    lineCtrl?.updateDataSource(updatedDataIndexes: <int>[0, 1]);
  }

  @override
  void update(ChartData data) {
    if (isRunning) {
      timeDiff = mvcDuration - data.time;
      if (timeDiff == 0) {
        isComplete = true;
        reset();
      } else if (data.load > maxForce) {
        maxForce = data.load;
        _updateLine();
      }
    }
  }

  @override
  Future<void> start() async {
    if (!isRunning) {
      if (hasData) {
        await exit();
      } else {
        await super.start();
      }
    }
  }

  @override
  Future<void> reset() async {
    if (isRunning) {
      isRunning = isWorking = false;
      await super.reset();
      if (isComplete) await congratulate(context);
      await exit();
    }
  }

  @override
  Future<bool> exit() async {
    if (!hasData) return true;
    if (export == null) {
      export = Export(
        userId: userId,
        mvcValue: maxForce,
        timestamp: timestamp,
        isComplate: isComplete,
        progressorId: deviceName,
        exportData: exportDataList,
      );
      await boxExport.add(export!);
    }
    if (isRunning) return stopWeightMeas().then((_) => true);
    final bool? result = await submitData(context, export!);
    if (result == null) {
      return false;
    } else if (result) {
      hasData = false;
      export = null;
      maxForce = 0;
      timeDiff = mvcDuration.toDouble();
      _updateLine();
      clearGraphData();
    }
    return result;
  }
}
