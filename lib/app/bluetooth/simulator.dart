import 'dart:async';

import 'package:tendon_loader/app/graph/graph_handler.dart';
import 'package:tendon_loader/shared/models/chartdata.dart';

late Timer? _timer;
bool isSumulation = true;

void fakeStart() {
  bool up = true;

  double fakeLoad = 0;
  double fakeTime = 0;

  _timer = Timer.periodic(const Duration(milliseconds: 100), (Timer timer) {
    if (!isPause) {
      final ChartData element =
          ChartData(load: fakeLoad.abs(), time: fakeTime);
      // ignore: invalid_use_of_protected_member
      GraphHandler.exportData.add(element);
      GraphHandler.sink.add(element);
      if (timer.tick % 10 == 0) {
        fakeTime = timer.tick / 10;
      }
      if (up) {
        fakeLoad += .100;
        if (fakeLoad >= 8) {
          up = false;
        }
      } else {
        fakeLoad -= .100;
        if (fakeLoad <= 0) {
          up = true;
        }
      }
    }
  });
}

void fakeStop() {
  _timer?.cancel();
  _timer = null;
}
