/// MIT License
/// 
/// Copyright (c) 2021 Mitul Vaghamshi
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in all
/// copies or substantial portions of the Software.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tendon_loader/modal/chartdata.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/modal/prescription.dart';
import 'package:tendon_loader/screens/graph/dialogs_handler.dart';
import 'package:tendon_loader/screens/graph/graph_handler.dart';
import 'package:tendon_loader/utils/common.dart';
import 'package:tendon_loader/utils/themes.dart';

class ExerciseHandler extends GraphHandler {
  ExerciseHandler({required BuildContext context})
      : _pre = settingsState.prescription!,
        super(context: context, lineData: <ChartData>[
          ChartData(load: settingsState.prescription!.targetLoad),
          ChartData(
            time: 2,
            load: settingsState.prescription!.targetLoad,
          ),
        ]) {
    _clear();
  }

  int _minTime = 0;

  late int _set;
  late int _rep;
  late int _rest;
  late int _lapTime;
  late bool _isPush;
  late bool _isSetOver;
  final Prescription _pre;

  String get repCounter => '$_rep of ${_pre.reps}';
  String get setCounter => '$_set of ${_pre.sets}';
  String get timeCounter => '${_isPush ? 'Push' : 'Rest'}: $_lapTime Sec';
  TextStyle get timeStyle => _isPush ? tsB40B : tsR40B;

  void _clear() {
    _isPush = true;
    _minTime = 0;
    _lapTime = _pre.holdTime;
    _set = _rep = _rest = 1;
    _isSetOver = isHit = false;
    GraphHandler.clear();
  }

  @override
  void update(ChartData data) {
    if (isRunning && !_isSetOver) {
      isHit = data.load > _pre.targetLoad;
      final int _time = data.time.truncate();
      if (!isPause && _time > _minTime) {
        _minTime = _time;
        if (_lapTime-- == 0) {
          if (_isPush) {
            _isPush = false;
            _rep++;
            _lapTime = _pre.restTime;
            if (_rep > _pre.reps && _rest > _pre.reps - 1) {
              _set++;
              if (_set > _pre.sets) {
                isComplete = true;
                stop();
              } else {
                _rest = _rep = 1;
                _isPush = _isSetOver = true;
                _lapTime = _pre.holdTime;
                _setOver();
              }
            }
          } else {
            _rest++;
            _isPush = true;
            _lapTime = _pre.holdTime;
          }
          HapticFeedback.heavyImpact();
        }
      }
    }
  }

  Future<void> _setOver() async {
    await Future<void>.microtask(() async {
      final bool? result = await startCountdown(
        context,
        title: 'Set Over, Rest!!!',
        duration: Duration(seconds: _pre.setRest),
      );
      await (result ?? false ? start : stop)();
    });
  }

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
  void pause() {
    if (isRunning) isPause = true;
  }

  @override
  Future<void> stop() async {
    if (isRunning) {
      isRunning = false;
      await super.stop();
      _clear();
      if (isComplete) await congratulate(context);
      await exit();
    }
  }

  @override
  Future<bool> exit() async {
    if (!hasData) return true;
    export ??= Export(prescription: _pre);
    return super.exit();
  }
}
