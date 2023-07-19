import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tendon_loader/app/graph/graph_handler.dart';
import 'package:tendon_loader/models/chartdata.dart';
import 'package:tendon_loader/prescription/prescription.dart';

class ExerciseHandler extends GraphHandler {
  ExerciseHandler({required this.prescription, required super.onCountdown})
      : super(lineData: <ChartData>[
          ChartData(load: prescription.targetLoad),
          ChartData(time: 2, load: prescription.targetLoad),
        ]) {
    _clear();
  }

  final Prescription prescription;

  late int _lapTime;
  late int _setCount;
  late int _repCount;
  late int _restCount;
  late bool _isPushing;
  late bool _isSetOver;

  int _minTime = 0;

  @override
  Future<void> start() async {
    if (isPause && isRunning) {
      isPause = false;
    } else if (_isSetOver && isRunning) {
      _isSetOver = false;
    } else if (hasData && !isRunning) {
      await exit();
    } else {
      await super.start();
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

  /// Session (Sets: 3, Reps: 3):
  /// (Rest: Rep - 1)
  ///
  ///   Set-1:
  ///     Rep-1:
  ///     Rest-1:
  ///     Rep-2:
  ///     Rest-2:
  ///     Rep-3:
  ///
  ///   Set-2:
  ///     Rep-1:
  ///     Rest-1:
  ///     Rep-2:
  ///     Rest-2:
  ///     Rep-3:
  ///
  ///   Set-3:
  ///     Rep-1:
  ///     Rest-1:
  ///     Rep-2:
  ///     Rest-2:
  ///     Rep-3:
  ///
  @override
  void update(ChartData data) {
    // If session is running and Set is not completed
    if (isRunning && !_isSetOver) {
      // Does user touches target line?
      isHit = data.load > prescription.targetLoad;
      // Current time from (Progressor) device
      // Clamp [1.000000 ... 1.999999] to 1
      // As this method gets called for every sub-second
      final int time = data.time.truncate();
      // Session (app) is not paused by user and,
      // do not run for same sub-second portion
      if (!isPause && time > _minTime) {
        // Raise the time bar
        _minTime = time;
        // Lap time == Rep time or Rest time
        // If the current lap is over?
        // reduce lap time by 1 sec otherwise
        if (_lapTime-- == 0) {
          // Is user pushing the progressor?
          // Pull (-ve), Push (+ve) interactions are the same.
          // User has to "Push", and "Rest" for specified times.
          if (_isPushing) {
            // Mark next cycle as Rest phase.
            _isPushing = false;
            // Advance to next rep for current Set
            _repCount++;
            // Let lap to run through Rest time
            // folloeing every rep, except before first and after last rep
            // i.e. [Rep1, Rest1, Rep2, Rest2, ..., RestN-1, RepN]
            _lapTime = prescription.restTime;
            // If all reps were completed for current Set and,
            // all rests also completed?
            // There will be N-1 rests for N reps.
            if (_repCount > prescription.reps &&
                _restCount > prescription.reps - 1) {
              // Advence to next Set for current Session
              _setCount++;
              // Is user done with all the Sets?
              if (_setCount > prescription.sets) {
                // This will indicate data status in database as:
                // "Complete", "Incomplete"
                // It will be always "Incomplete",
                // if user left session unfinished
                isComplete = true;
                // Stop the session and complete remaining steps
                stop();
              } else {
                // Preparing the next Set
                // Reset rep and rest counters
                _restCount = _repCount = 1;
                // Disable Rest phase, and mark Set as completed
                // Do not revisit for completed set,
                // as Progressor is still producing data, which we don't need.
                _isPushing = _isSetOver = true;
                // Reset lap (rep) time to follow Hold time,
                // which currently at Rest time.
                // During Hold time user will interact with the Progressor, and
                // for Rest time do nothing...
                _lapTime = prescription.holdTime;
                // Show a countdown timer before every Set starts.
                _setComplete();
              }
            }
          } else {
            // Lap time over for current Rest phase.
            // Advance rest counter
            _restCount++;
            // Mark next cycle as Rep phase.
            _isPushing = true;
            // and let the lap follow the rep time.
            _lapTime = prescription.holdTime;
          }
          // Create vibration feedback on Rep, and Rest completion.
          HapticFeedback.heavyImpact();
        }
      }
    }
  }

  @override
  void pause() {
    if (isRunning) isPause = true;
  }

  @override
  Future<String> exit() async {
    if (!hasData) return '';
    // export ??= Export(prescription: prescription);
    return super.exit();
  }
}

extension on ExerciseHandler {
  void _clear() {
    _isPushing = true;
    _minTime = 0;
    _lapTime = prescription.holdTime;
    _setCount = _repCount = _restCount = 1;
    _isSetOver = isHit = false;
    GraphHandler.clear();
  }

  Future<void> _setComplete() async {
    await Future<void>.microtask(() async {
      final bool? result = await onCountdown(
        'Set Over, Rest!!!',
        Duration(seconds: prescription.setRest),
      );
      await (result ?? false ? start : stop)();
    });
  }
}

extension ExExerciseHandler on ExerciseHandler {
  String get repCounter => '$_repCount of ${prescription.reps}';
  String get setCounter => '$_setCount of ${prescription.sets}';
  String get timeCounter => '${_isPushing ? 'Push' : 'Rest'}: $_lapTime Sec';
  TextStyle get timeStyle => _isPushing
      ? const TextStyle(
          fontSize: 40, color: Color(0xff000000), fontWeight: FontWeight.bold)
      : const TextStyle(
          fontSize: 40, color: Color(0xffff534d), fontWeight: FontWeight.bold);
}
