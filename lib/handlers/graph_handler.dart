import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/handlers/device_handler.dart';
import 'package:tendon_loader/modal/chartdata.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/utils/clip_player.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/helper.dart';

class GraphHandler {
  GraphHandler({required this.context, this.lineData}) : userId = context.model.currentUser!.id {
    isRunning = isComplete = hasData = false;
  }

  Export? export;
  late bool hasData;
  final String userId;
  late bool isRunning;
  late bool isComplete;
  late Timestamp timestamp;
  List<ChartData>? lineData;
  final BuildContext context;
  ChartSeriesController? lineCtrl;
  ChartSeriesController? graphCtrl;
  final List<ChartData> graphData = <ChartData>[];

  Future<void> start() async {
    if (await startCountdown(context) ?? false) {
      play(true);
      hasData = true;
      isRunning = true;
      isComplete = false;
      exportDataList.clear();
      timestamp = Timestamp.now();
      await startWeightMeas();
    }
  }

  void stop() {}

  void update(ChartData data) {}

  Future<void> reset() async {
    await stopWeightMeas();
     play(false);
  }

  Future<bool> exit() async {
    if (isRunning) await reset();
    exportDataList.clear();
    return true;
  }
}
