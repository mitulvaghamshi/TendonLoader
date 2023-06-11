import 'dart:async';

import 'package:tendon_loader/common/models/chartdata.dart';
import 'package:tendon_loader/screens/graph/models/graph_handler.dart';

mixin Simulator {
  static bool useSimulator = true;
  static Timer? _timer;

  static void startSimulator() {
    bool isGrowing = true;
    double fakeLoad = 0;
    double fakeTime = 0;

    _timer ??= Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!isPause) {
        final ChartData data = ChartData(load: fakeLoad.abs(), time: fakeTime);
        // ignore: invalid_use_of_protected_member
        GraphHandler.exportData.add(data);
        GraphHandler.sink.add(data);
        if (timer.tick % 20 == 0) fakeTime = timer.tick / 20;
        if (isGrowing) {
          fakeLoad += .100;
          isGrowing = fakeLoad <= 20;
        } else {
          fakeLoad -= .100;
          isGrowing = fakeLoad <= 0;
        }
      }
    });
  }

  static void stopSimulator() {
    _timer?.cancel();
    _timer = null;
  }
}
