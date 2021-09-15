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
import 'package:tendon_loader/screens/graph/dialogs_handler.dart';
import 'package:tendon_loader/screens/graph/graph_handler.dart';
import 'package:tendon_loader/utils/common.dart';

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
    if (!isRunning) hasData ? await exit() : await super.start();
  }

  @override
  Future<void> stop() async {
    if (isRunning) {
      isRunning = false;
      await super.stop();
      if (isComplete) await congratulate(context);
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
