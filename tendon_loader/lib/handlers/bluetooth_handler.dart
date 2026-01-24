import 'dart:async' show Completer, Future;
import 'dart:io' show Platform;

import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/handlers/graph_handler.dart';
import 'package:tendon_loader/utils/constants.dart';
import 'package:tendon_loader/utils/simulator.dart';

class Progressor {
  factory Progressor() => _instance ??= Progressor._();

  Progressor._();

  static Progressor? _instance;

  static Progressor get instance => Progressor();

  bool _isRunning = false;

  Completer<bool>? _completer;
  BluetoothDevice? _device;

  BluetoothCharacteristic? _dataChar;
  BluetoothCharacteristic? _controlChar;
  String get deviceName => _device == null
      ? 'Unknown'
      : _device!.name.isEmpty
      ? _device!.id.id
      : _device!.name;

  BluetoothDevice? get progressor => _device;

  Future<void> get _delayedStart async =>
      Future<void>.delayed(const .new(milliseconds: 800), startProgresssor);

  Future<bool> call({required BluetoothDevice device}) => init(device: device);

  Future<void> disconnect({bool sleep = false}) async {
    if (_device == null) return;
    if (sleep) {
      await _controlChar!.write(<int>[Cmd.enterSleep]);
    } else {
      await _device!.disconnect();
    }
    _isRunning = false;
    _device = _dataChar = _controlChar = _completer = null;
  }

  Future<bool> init({required BluetoothDevice device}) async {
    if (_device != null && _dataChar != null && _controlChar != null) {
      return _delayedStart.then((_) => true);
    } else if (_completer == null) {
      _completer = Completer<bool>();
      for (var s in await device.discoverServices()) {
        for (var c in s.characteristics) {
          if (c.uuid == Guid(DeviceUUID.controller)) {
            _controlChar = c;
          } else if (c.uuid == Guid(DeviceUUID.data)) {
            _dataChar = c;
          }
        }
      }
      if (_dataChar != null && _controlChar != null) {
        await _dataChar!.setNotifyValue(true);
        if (Platform.isAndroid) await device.requestMtu(120);
        _dataChar!.value.listen(GraphHandler.onData);
        _device = device;
        _delayedStart.then((_) => _completer!.complete(true));
      }
    }
    return _completer!.future;
  }

  Future<void> sleep() async => disconnect(sleep: true);

  Future<void> startProgresssor() async {
    if (_isRunning) return;
    _isRunning = true;
    if (Simulator.enabled) return Simulator.startSimulator();
    await _controlChar!.write(<int>[Cmd.startWeightMeas]);
  }

  Future<void> startScan() async =>
      FlutterBlue.instance.startScan(timeout: const .new(seconds: 5));

  Future<void> stopProgressor() async {
    if (!_isRunning) return;
    _isRunning = false;
    if (Simulator.enabled) return Simulator.stopSimulator();
    await _controlChar!.write(<int>[Cmd.stopWeightMeas]);
  }

  Future<void> tare() async {
    if (!_isRunning) return;
    _isRunning = false;
    await _controlChar!.write(<int>[Cmd.tareScale]);
    await Future.delayed(const .new(milliseconds: 500));
    await _controlChar!.write(<int>[Cmd.startWeightMeas]);
    await Future.delayed(const .new(milliseconds: 500));
    await _controlChar!.write(<int>[Cmd.stopWeightMeas]);
  }
}
