import 'dart:async' show Completer, Future;
import 'dart:io' show Platform;

import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/handlers/graph_handler.dart';
import 'package:tendon_loader/utils/constants.dart';
import 'package:tendon_loader/utils/simulator.dart';

class Progressor {
  factory Progressor() => _instance ??= Progressor._();

  Progressor._();

  call({required BluetoothDevice device}) => init(device: device);

  static Progressor? _instance;
  static Progressor get instance => Progressor();

  bool _isRunning = false;
  Completer<bool>? _completer;

  BluetoothDevice? _device;
  BluetoothCharacteristic? _dataChar;
  BluetoothCharacteristic? _controlChar;

  BluetoothDevice? get progressor => _device;

  String get deviceName =>
      _device == null
          ? 'Unknown'
          : _device!.name.isEmpty
          ? _device!.id.id
          : _device!.name;

  Future<void> startScan() async =>
      FlutterBlue.instance.startScan(timeout: const Duration(seconds: 5));

  Future<void> tare() async {
    if (!_isRunning) return;
    _isRunning = false;
    await _controlChar!.write(<int>[Commands.tareScale]);
    await Future.delayed(const Duration(milliseconds: 500));
    await _controlChar!.write(<int>[Commands.startWeightMeas]);
    await Future.delayed(const Duration(milliseconds: 500));
    await _controlChar!.write(<int>[Commands.stopWeightMeas]);
  }

  Future<void> startProgresssor() async {
    if (_isRunning) return;
    _isRunning = true;
    if (Simulator.enabled) return Simulator.startSimulator();
    await _controlChar!.write(<int>[Commands.startWeightMeas]);
  }

  Future<void> stopProgressor() async {
    if (!_isRunning) return;
    _isRunning = false;
    if (Simulator.enabled) return Simulator.stopSimulator();
    await _controlChar!.write(<int>[Commands.stopWeightMeas]);
  }

  Future<void> sleep() async => disconnect(sleep: true);

  Future<void> disconnect({bool sleep = false}) async {
    if (_device == null) return;
    if (sleep) {
      await _controlChar!.write(<int>[Commands.enterSleep]);
    } else {
      await _device!.disconnect();
    }
    _isRunning = false;
    _device = _dataChar = _controlChar = _completer = null;
  }

  Future<void> get _delayedStart async =>
      Future<void>.delayed(const Duration(milliseconds: 800), startProgresssor);

  Future<bool> init({required BluetoothDevice device}) async {
    if (_device != null && _dataChar != null && _controlChar != null) {
      return _delayedStart.then((_) => true);
    } else if (_completer == null) {
      _completer = Completer<bool>();
      for (BluetoothService s in await device.discoverServices()) {
        for (BluetoothCharacteristic c in s.characteristics) {
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
}
