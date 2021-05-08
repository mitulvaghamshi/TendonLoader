import 'dart:async';
import 'dart:isolate';

import 'package:tendon_loader/app/handler/bluetooth_handler.dart';
import 'package:tendon_loader/shared/constants.dart';
import 'package:tendon_loader/shared/extensions.dart';
import 'package:tendon_loader/shared/modal/chartdata.dart';

class DataHandler {
  final ReceivePort _receivePort = ReceivePort();
  Isolate _isolate;

  Future<void> start() async {
    _isolate = await Isolate.spawn(_execute, _receivePort.sendPort);
    await Bluetooth.startWeightMeas();
  }

  Future<void> reset() async {
    await Bluetooth.stopWeightMeas();
    _receivePort.sendPort.send(ChartData());
    _isolate.kill();
  }

  void dispose() => _receivePort.close();

  Stream<dynamic> get stream => _receivePort.asBroadcastStream();

  void listen(dynamic _port) => Bluetooth.listen((_port as SendPort).send);

  static Future<void> _execute(SendPort _sendPort) async {
    final ReceivePort _receivePort = ReceivePort();
    _sendPort.send(_receivePort.sendPort);
    double _lastMilliSec = 0;
    _receivePort.listen((dynamic _message) {
      final List<int> _data = _message as List<int>;
      if (_data.isNotEmpty && _data[0] == Progressor.RES_WEIGHT_MEAS) {
        for (int x = 2; x < _data.length; x += 8) {
          final double _weight = _data.getRange(x, x + 4).toList().toWeight;
          final double _time = _data.getRange(x + 4, x + 8).toList().toTime;
          // if (_time > _lastMilliSec) {
          //   _lastMilliSec = _time;
          _sendPort.send(ChartData(load: _weight, time: _time));
          // }
        }
      }
    });
  }
}
