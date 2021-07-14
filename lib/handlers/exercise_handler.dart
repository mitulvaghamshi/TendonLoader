import 'package:flutter/material.dart';
import 'package:tendon_loader/handlers/device_handler.dart';
import 'package:tendon_loader/handlers/graph_handler.dart';
import 'package:tendon_loader/modal/chartdata.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/modal/prescription.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/helper.dart';
import 'package:tendon_loader/utils/initializer.dart';
import 'package:tendon_loader/utils/themes.dart';

class ExerciseHandler extends GraphHandler {
  ExerciseHandler({required BuildContext context})
      : pre = context.model.prescription!,
        super(context: context, lineData: <ChartData>[
          ChartData(load: context.model.prescription!.targetLoad),
          ChartData(time: 2, load: context.model.prescription!.targetLoad),
        ]) {
    _clear();
  }

  int _minTime = 0;
  bool _isHit = false;

  late int sets;
  late int reps;
  late int rests;
  late int lapTimer;
  late bool isHold;
  late bool isSetOver;
  final Prescription pre;

  String get lapTime => '${isHold ? 'Hold' : 'Rest'}: $lapTimer Sec';
  String get counterValue => 'Set: $sets/${pre.sets} • Rep: $reps/${pre.reps}';
  Color get feedColor => _isHit ? colorGoogleGreen : colorGoogleYellow;

  void _clear() {
    isHold = true;
    lapTimer = pre.holdTime;
    sets = reps = rests = 1;
    isSetOver = _isHit = false;
  }

  @override
  void update(ChartData data) {
    if (isRunning) {
      _isHit = data.load > pre.targetLoad;
      final int time = data.time.truncate();
      if (!isSetOver && time > _minTime) {
        _minTime = time;
        if (lapTimer-- == 0) {
          if (isHold) {
            isHold = false;
            reps++;
            lapTimer = pre.restTime;
            if (reps > pre.reps && rests > pre.reps - 1) {
              sets++;
              if (sets > pre.sets) {
                isComplete = true;
                reset();
              } else {
                onSetOver();
                rests = reps = 1;
                isHold = isSetOver = true;
                lapTimer = pre.holdTime;
              }
            }
          } else {
            rests++;
            isHold = true;
            lapTimer = pre.holdTime;
          }
        }
      }
    }
  }

  Future<void> onSetOver() async {
    await Future<void>.microtask(() async {
      final bool? result = await startCountdown(
        context,
        title: 'Set Over, Rest!!!',
        duration: Duration(seconds: pre.setRest),
      );
      await (result ?? false ? start : reset)();
    });
  }

  @override
  Future<void> start() async {
    if (isSetOver && isRunning) {
      isSetOver = false;
    } else if (!isRunning && hasData) {
      await exit();
    } else {
      await super.start();
    }
  }

  @override
  void stop() {
    if (isRunning) isSetOver = true;
  }

  @override
  Future<void> reset() async {
    if (isRunning) {
      isRunning = isWorking = false;
      await super.reset();
      _clear();
      _minTime = 0;
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
        prescription: pre,
        timestamp: timestamp,
        isComplate: isComplete,
        progressorId: deviceName,
        exportData: exportDataList,
      );
      await boxExport.add(export!);
    }
    if (isRunning) return stopWeightMeas().then((_) => true);
    final bool result = await submitData(context, export!) ?? true;
    if (result) {
      hasData = false;
      export = null;
    }
    return result;
  }
}
