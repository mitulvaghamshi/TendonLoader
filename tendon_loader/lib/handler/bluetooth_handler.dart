import 'dart:async' show Completer, Future;
import 'dart:io' show Platform;

import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/handler/graph_handler.dart';
import 'package:tendon_loader/utils/constants.dart';
import 'package:tendon_loader/utils/simulator.dart';

class Progressor._() {
  factory() => _instance;

  static final _instance = Progressor._();
  static Progressor get instance => _instance;

  bool _isListening = false;

  Completer<bool>? _completer;

  BluetoothDevice? _device;
  BluetoothCharacteristic? _dataChar;
  BluetoothCharacteristic? _controlChar;
}

extension ProgressorExt on Progressor {
  BluetoothDevice? get progressor => _device;

  String get deviceName => _device == null
      ? 'Unknown'
      : _device!.name.isEmpty
      ? _device!.id.id
      : _device!.name;

  Future<void> _delayedStart() async =>
      Future.delayed(const .new(milliseconds: 800), startListening);

  Future<bool> init(BluetoothDevice device) async {
    if (_device != null && _dataChar != null && _controlChar != null) {
      return _delayedStart().then((_) => true);
    }
    if (_completer == null) {
      _completer = .new();
      for (var service in await device.discoverServices()) {
        for (var charecteristic in service.characteristics) {
          if (charecteristic.uuid == Guid(DeviceUUID.controller)) {
            _controlChar = charecteristic;
          } else if (charecteristic.uuid == Guid(DeviceUUID.data)) {
            _dataChar = charecteristic;
          }
        }
      }
      if (_dataChar != null && _controlChar != null) {
        await _dataChar!.setNotifyValue(true);
        if (Platform.isAndroid) {
          await device.requestMtu(120);
        }
        _dataChar!.value.listen(GraphHandler.onData);
        _device = device;
        await _delayedStart().then((_) => _completer!.complete(true));
      }
    }
    return _completer!.future;
  }

  Future<void> scan() async =>
      FlutterBlue.instance.startScan(timeout: const .new(seconds: 5));

  Future<void> startListening() async {
    if (_isListening) {
      return;
    }
    _isListening = true;
    if (Simulator.enabled) {
      return Simulator.startSimulator();
    }
    await _controlChar!.write([Cmd.startWeightMeas]);
  }

  Future<void> stopListening() async {
    if (!_isListening) {
      return;
    }
    _isListening = false;
    if (Simulator.enabled) {
      return Simulator.stopSimulator();
    }
    await _controlChar!.write([Cmd.stopWeightMeas]);
  }

  Future<void> tare() async {
    if (!_isListening) {
      return;
    }
    _isListening = false;
    await _controlChar!.write([Cmd.tareScale]);
    await Future<void>.delayed(const .new(milliseconds: 500));
    await _controlChar!.write([Cmd.startWeightMeas]);
    await Future<void>.delayed(const .new(milliseconds: 500));
    await _controlChar!.write([Cmd.stopWeightMeas]);
  }

  Future<void> sleep() async => disconnect(sleep: true);

  Future<void> disconnect({bool sleep = false}) async {
    if (_device == null) {
      return;
    }
    if (sleep) {
      await _controlChar!.write([Cmd.enterSleep]);
    } else {
      await _device!.disconnect();
    }
    _isListening = false;
    _device = _dataChar = _controlChar = _completer = null;
  }
}
