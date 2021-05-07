import 'dart:async';
import 'dart:isolate';

import 'package:tendon_loader/app/handler/bluetooth_handler.dart';
import 'package:tendon_loader/shared/constants.dart';
import 'package:tendon_loader/shared/extensions.dart';
import 'package:tendon_loader/shared/modal/chartdata.dart';

class DataHandler {
  ReceivePort receivePort = ReceivePort();
  Completer<SendPort> completer;
  // SendPort sendPort;
  Isolate _isolate;

  ReceivePort get stream => receivePort;

  Future<void> start() async {
    completer = Completer<SendPort>();
    _isolate = await Isolate.spawn(_execute, receivePort.sendPort);
  }

  Future<void> setPort(dynamic port) async {
    // completer.complete(port as SendPort);
    // Future<void>.delayed(const Duration(seconds: 1), () {
    //   Bluetooth.listen(sendPort.send);
    // });
  }

  Future<void> reset() async {
    await Bluetooth.stopWeightMeas();
    // sendPort.send(<int>[]);
    _isolate.kill();
  }

  void dispose() => receivePort.close();

  static Future<void> _execute(SendPort _sPort) async {
    final ReceivePort _rPort = ReceivePort();
    _sPort.send(_rPort.sendPort);
    double _lastMilliSec = 0;
    _rPort.listen((dynamic message) {
      final List<int> data = message as List<int>;
      if (data.isNotEmpty && data[0] == Progressor.RES_WEIGHT_MEAS) {
        for (int x = 2; x < data.length; x += 8) {
          final double weight = data.getRange(x, x + 4).toList().toWeight;
          final double time = data.getRange(x + 4, x + 8).toList().toTime;
          if (time > _lastMilliSec) {
            _lastMilliSec = time;
            _sPort.send(ChartData(load: weight, time: time));
          }
        }
      } else {
        _rPort.close();
      }
    });
  }
}
