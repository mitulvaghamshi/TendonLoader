import 'package:flutter/material.dart';
import 'package:tendon_loader/handlers/graph_handler.dart';
import 'package:tendon_loader/modal/chartdata.dart';
import 'package:tendon_loader/utils/extension.dart';

class LiveDataHandler extends GraphHandler {
  LiveDataHandler({required BuildContext context}) : super(context: context);

  double time = 0;

  String get elapsed => time.toTime;

  @override
  Future<void> reset() async {
    if (isRunning) {
      isRunning = false;
      await super.reset();
    }
  }

  @override
  Future<void> start() async {
    if (!isRunning) await super.start();
  }

  @override
  void update(ChartData data) {
    if (isRunning) time = data.time;
  }
}
