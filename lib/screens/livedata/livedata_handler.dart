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
import 'package:tendon_loader/modal/chartdata.dart';
import 'package:tendon_loader/screens/graph/graph_handler.dart';

class LiveDataHandler extends GraphHandler {
  LiveDataHandler({required BuildContext context}) : super(context: context);

  double _time = 0;

  String get elapsed {
    return '🕒 ${_time ~/ 60}:${(_time % 60).toStringAsFixed(0).padLeft(2, '0')} Sec';
  }

  @override
  Future<void> start() async {
    if (!isRunning) await super.start();
  }

  @override
  Future<void> stop() async {
    if (isRunning) {
      isRunning = hasData = false;
      await super.stop();
      _time = 0;
      GraphHandler.clear();
    }
  }

  @override
  void update(ChartData data) {
    if (isRunning) _time = data.time;
  }

  @override
  Future<bool> exit() async {
    await stop();
    return super.exit();
  }
}
