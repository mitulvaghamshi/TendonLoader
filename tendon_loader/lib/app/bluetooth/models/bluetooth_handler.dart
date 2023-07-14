import 'dart:async';
import 'dart:io';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/app/bluetooth/models/simulator.dart';
import 'package:tendon_loader/app/graph/graph_handler.dart';
import 'package:tendon_loader/common/constants.dart';

mixin Progressor {
  static bool _isRunning = false;
  static Completer<bool>? _completer;
  static BluetoothDevice? _device;
  static BluetoothCharacteristic? _dataChar;
  static BluetoothCharacteristic? _controlChar;

  BluetoothDevice? get progressor => _device;

  String get progressorName => _device == null
      ? 'Not connected!'
      : _device!.name.isEmpty
          ? _device!.id.id
          : _device!.name;

  Future<void> startScan() async =>
      FlutterBlue.instance.startScan(timeout: const Duration(seconds: 2));

  Future<void> tare() async {
    if (_isRunning) {
      _isRunning = false;
      await Future.wait(<Future<void>>[
        _controlChar!.write(<int>[Commands.tareScale]),
        Future<void>.delayed(const Duration(milliseconds: 500)),
        _controlChar!.write(<int>[Commands.startWeightMeas]),
        Future<void>.delayed(const Duration(milliseconds: 500)),
        _controlChar!.write(<int>[Commands.stopWeightMeas]),
      ]);
    }
  }

  Future<void> startProgresssor() async {
    if (!_isRunning) {
      _isRunning = true;
      // Simulator
      if (Simulator.enabled) {
        Simulator.startSimulator();
      } else {
        await _controlChar!.write(<int>[Commands.startWeightMeas]);
      }
    }
  }

  Future<void> stopProgressor() async {
    if (_isRunning) {
      _isRunning = false;
      if (Simulator.enabled) {
        Simulator.stopSimulator();
      } else {
        await _controlChar!.write(<int>[Commands.stopWeightMeas]);
      }
    }
  }

  Future<void> disconnect({bool sleep = false}) async {
    if (_device != null) {
      if (sleep) {
        await _controlChar!.write(<int>[Commands.enterSleep]);
      } else {
        await _device!.disconnect();
      }
      _isRunning = false;
      _device = _dataChar = _controlChar = _completer = null;
      GraphHandler.disposeGraphData();
    }
  }

  Future<void> get _delayedStart async =>
      Future<void>.delayed(const Duration(milliseconds: 800), startProgresssor);

  Future<bool> initializeWith(final BluetoothDevice device) async {
    if (_device != null && _dataChar != null && _controlChar != null) {
      return _delayedStart.then((_) => true);
    } else if (_completer == null) {
      _completer = Completer<bool>();
      for (final BluetoothService s in await device.discoverServices()) {
        for (final BluetoothCharacteristic c in s.characteristics) {
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
