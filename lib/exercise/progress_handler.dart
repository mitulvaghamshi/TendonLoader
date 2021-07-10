import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/device/handler/device_handler.dart';
import 'package:tendon_loader/modal/prescription.dart';
import 'package:tendon_loader/utils/clip_player.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/helper.dart';

class ProgressHandler {
  ProgressHandler({required this.onExit, required this.context})
      : pre = context.model.prescription!,
        userId = context.model.currentUser!.id {
    isRunning = isComplete = hasData = false;
    _clear();
  }

  int _minTime = 0;

  late int sets;
  late int reps;
  late int rests;
  late int lapTimer;
  late bool isHold;
  late bool hasData;
  late bool isSetOver;
  late bool isRunning;
  late bool isComplete;
  late Timestamp timestamp;

  final String userId;
  final Prescription pre;
  final VoidCallback onExit;
  final BuildContext context;

  String get lapTime => '${isHold ? 'Hold' : 'Rest'}: $lapTimer Sec';
  String get progress => 'Set: $sets/${pre.sets} • Rep: $reps/${pre.reps}';

  void _clear() {
    isHold = true;
    lapTimer = pre.holdTime;
    sets = reps = rests = 1;
    isSetOver = false;
  }

  Future<void> start() async {
    if (isSetOver && isRunning) {
      isSetOver = false;
    } else if (!isRunning && hasData) {
      onExit();
    } else if (await startCountdown(context) ?? false) {
      play(true);
      hasData = true;
      isRunning = true;
      isComplete = false;
      exportDataList.clear();
      timestamp = Timestamp.now();
      await startWeightMeas();
    }
  }

  void stop() {
    if (isRunning) isSetOver = true;
  }

  Future<void> reset() async {
    if (isRunning) {
      _clear();
      play(false);
      _minTime = 0;
      isRunning = false;
      await stopWeightMeas();
      if (isComplete) await congratulate(context);
      onExit();
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

  void update(int time) {
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
