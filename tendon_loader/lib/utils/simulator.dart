import 'dart:async';

import 'package:tendon_loader/handlers/graph_handler.dart';
import 'package:tendon_loader/models/chartdata.dart';

mixin Simulator {
  static const enabled = bool.fromEnvironment('USE_SIMULATOR');

  static Timer? _timer;

  static void startSimulator() {
    bool doIncrease = true;
    double fakeLoad = 0;
    double fakeTime = 0;

    _timer ??= Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!isPause) {
        final data = ChartData(load: fakeLoad.abs(), time: fakeTime);
        // ignore: invalid_use_of_protected_member
        GraphHandler.exportData.add(data);
        GraphHandler.sink.add(data);
        if (timer.tick % 20 == 0) fakeTime = timer.tick / 20;
        if (doIncrease) {
          fakeLoad += .100;
          doIncrease = fakeLoad <= 20;
        } else {
          fakeLoad -= .100;
          doIncrease = fakeLoad <= 0;
        }
      }
    });
  }

  static void stopSimulator() {
    _timer?.cancel();
    _timer = null;
  }
}
