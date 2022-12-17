```dart
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tendon_loader/screens/graph/graph_handler.dart';
import 'package:tendon_loader/modal/chartdata.dart';

Future<void> useEmulator() async {
  const String host = '192.168.0.57';
  await FirebaseAuth.instance.useAuthEmulator(host, 10001);
  FirebaseFirestore.instance.useFirestoreEmulator(host, 10002);
}

// Simuation block start
late Timer? _timer;
late bool isSumulation = false;

void fakeStart() {
  double _fakeLoad = 0;
  double _fakeTime = 0;
  bool _up = true;
  _timer = Timer.periodic(const Duration(milliseconds: 100), (Timer timer) {
    if (!isPause) {
      final ChartData element = ChartData(load: _fakeLoad.abs(), time: _fakeTime);
      // ignore: invalid_use_of_protected_member
      GraphHandler.exportData.add(element);
      GraphHandler.sink.add(element);
      if (timer.tick % 10 == 0) _fakeTime = timer.tick / 10;
      if (_up) {
        _fakeLoad += .100;
        if (_fakeLoad >= 8) _up = false;
      } else {
        _fakeLoad -= .100;
        if (_fakeLoad <= 0) _up = true;
      }
    }
  });
}

void fakeStop() => _timer?.cancel();
// Simulation block end
```
