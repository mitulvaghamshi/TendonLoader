import 'package:flutter/material.dart';
import 'package:tendon_loader_lib/tendon_loader_lib.dart';

class ProgressHandler {
  ProgressHandler({
    required this.pre,
    required this.onReset,
    required this.onSetOver,
    this.isHold = true,
    this.isSetOver = false,
    this.isRunning = false,
    this.isComplete = false,
  })  : lapTimer = pre.holdTime,
        sets = 1,
        reps = 1,
        rests = 1;

  int sets;
  int reps;
  int rests;
  int lapTimer;
  bool isHold;
  bool isSetOver;
  bool isRunning;
  bool isComplete;
  final Prescription pre;
  final VoidCallback onReset;
  final VoidCallback onSetOver;

  String get lapTime => '${isHold ? 'Hold' : 'Rest'}: $lapTimer Sec';
  String get progress => 'Set: $sets/${pre.sets} • Rep: $reps/${pre.reps}';

  void reset() {
    isHold = true;
    isSetOver = false;
    sets = 1;
    reps = 1;
    rests = 1;
    lapTimer = pre.holdTime;
  }

  void update() {
    if (lapTimer-- == 0) {
      if (isHold) {
        isHold = false;
        reps++;
        lapTimer = pre.restTime;
        if (reps > pre.reps&& rests > pre.reps- 1) {
          sets++;
          if (sets > pre.sets) {
            isComplete = true;
            onReset();
            reset();
          } else {
            onSetOver();
            rests = 1;
            reps = 1;
            isHold = true;
            isSetOver = true;
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
