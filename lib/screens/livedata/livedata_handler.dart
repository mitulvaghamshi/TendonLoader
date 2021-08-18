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
