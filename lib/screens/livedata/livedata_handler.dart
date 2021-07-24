import 'package:flutter/material.dart';
import 'package:tendon_loader/handlers/graph_handler.dart';
import 'package:tendon_loader/modal/chartdata.dart';
import 'package:tendon_loader/utils/extension.dart';

class LiveDataHandler extends GraphHandler {
  LiveDataHandler({required BuildContext context}) : super(context: context);

  double time = 0;

  String get elapsed => time.toTime;

  @override
  Future<void> start() async {
    if (!isRunning) await super.start();
  }

  @override
  Future<void> stop() async {
    if (isRunning) {
      isRunning = hasData = false;
      await super.stop();
      time = 0;
      GraphHandler.clear();
    }
  }

  @override
  void update(ChartData data) {
    if (isRunning) time = data.time;
  }

  @override
  Future<bool> exit() async {
    await stop();
    return super.exit();
  }
}
