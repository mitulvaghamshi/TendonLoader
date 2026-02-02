import 'dart:async';

import 'package:api_server/api_server.dart';
import 'package:flutter/foundation.dart';
import 'package:tendon_loader/handler/graph_handler.dart';

@immutable
mixin Simulator {
  static const enabled = bool.fromEnvironment('USE_SIMULATOR');

  static Timer? _timer;

  static void startSimulator() {
    bool doIncrease = true;
    double fakeLoad = 0;
    double fakeTime = 0;

    _timer ??= .periodic(const .new(milliseconds: 50), (timer) {
      if (isPause) return;
      final data = ChartData(load: fakeLoad.abs(), time: fakeTime);
      // ignore: invalid_use_of_protected_member
      GraphHandler.exportData.add(data);
      GraphHandler.sink.add(data);
      if (timer.tick % 20 == 0) {
        fakeTime = timer.tick / 20;
      }
      if (doIncrease) {
        fakeLoad += .100;
        doIncrease = fakeLoad <= 20;
      } else {
        fakeLoad -= .100;
        doIncrease = fakeLoad <= 0;
      }
    });
  }

  static void stopSimulator() {
    _timer?.cancel();
    _timer = null;
  }
}
