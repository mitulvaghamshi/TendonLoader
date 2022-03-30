import 'dart:async';

import 'package:tendon_loader/app/graph/graph_handler.dart';
import 'package:tendon_loader/shared/models/chartdata.dart';

late Timer? _timer;
late bool isSumulation = true;

void fakeStart() {
  bool _up = true;

  double _fakeLoad = 0;
  double _fakeTime = 0;

  _timer = Timer.periodic(const Duration(milliseconds: 100), (Timer timer) {
    if (!isPause) {
      final ChartData element =
          ChartData(load: _fakeLoad.abs(), time: _fakeTime);
      // ignore: invalid_use_of_protected_member
      GraphHandler.exportData.add(element);
      GraphHandler.sink.add(element);
      if (timer.tick % 10 == 0) {
        _fakeTime = timer.tick / 10;
      }
      if (_up) {
        _fakeLoad += .100;
        if (_fakeLoad >= 8) {
          _up = false;
        }
      } else {
        _fakeLoad -= .100;
        if (_fakeLoad <= 0) {
          _up = true;
        }
      }
    }
  });
}

void fakeStop() {
  _timer?.cancel();
  _timer = null;
}
