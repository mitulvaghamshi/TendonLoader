import 'dart:async';
import 'dart:io';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/app/bluetooth/simulator.dart';
import 'package:tendon_loader/app/graph/graph_handler.dart';
import 'package:tendon_loader/shared/utils/constants.dart';

bool _isRunning = false;
Completer<bool>? _completer;

BluetoothDevice? _device;
BluetoothCharacteristic? _dataChar;
BluetoothCharacteristic? _controlChar;

BluetoothDevice? get progressor => _device;

String get deviceName => _device == null
    ? 'Not connected!'
    : _device!.name.isEmpty
        ? _device!.id.id
        : _device!.name;

Future<void> startScan() async {
  await FlutterBlue.instance.startScan(
    timeout: const Duration(seconds: 2),
  );
}

Future<void> tareProgressor() async {
  if (_isRunning) {
    _isRunning = false;
    await Future.wait(<Future<void>>[
      _controlChar!.write(<int>[cmdTareScale]),
      Future<void>.delayed(const Duration(milliseconds: 500)),
      _controlChar!.write(<int>[cmdStartWeightMeas]),
      Future<void>.delayed(const Duration(milliseconds: 500)),
      _controlChar!.write(<int>[cmdStopWeightMeas]),
    ]);
  }
}

Future<void> startWeightMeas() async {
  if (!_isRunning) {
    _isRunning = true;
    // Simulator
    if (isSumulation) {
      fakeStart();
    } else {
      await _controlChar!.write(<int>[cmdStartWeightMeas]);
    }
  }
}

Future<void> stopWeightMeas() async {
  if (_isRunning) {
    _isRunning = false;
    if (isSumulation) {
      fakeStop();
    } else {
      await _controlChar!.write(<int>[cmdStopWeightMeas]);
    }
  }
}

Future<void> disconnectDevice({bool sleep = false}) async {
  if (_device != null) {
    if (sleep) {
      await _controlChar!.write(<int>[cmdEnterSleep]);
    } else {
      await _device!.disconnect();
    }
    _isRunning = false;
    _device = _dataChar = _controlChar = _completer = null;
  }
}

Future<bool> getProps(BluetoothDevice device) async {
  if (_device != null && _dataChar != null && _controlChar != null) {
    return Future<void>.delayed(
      const Duration(milliseconds: 800),
      startWeightMeas,
    ).then((_) => true);
  } else if (_completer == null) {
    _completer = Completer<bool>();
    for (final BluetoothService s in await device.discoverServices()) {
      for (final BluetoothCharacteristic c in s.characteristics) {
        if (c.uuid == Guid(uuidControl)) {
          _controlChar = c;
        } else if (c.uuid == Guid(uuidData)) {
          _dataChar = c;
        }
      }
    }
    if (_dataChar != null && _controlChar != null) {
      await _dataChar!.setNotifyValue(true);
      if (Platform.isAndroid) await device.requestMtu(120);
      _dataChar!.value.listen(GraphHandler.onData);
      _device = device;
      await Future<void>.delayed(
        const Duration(milliseconds: 800),
        startWeightMeas,
      ).then((_) => _completer!.complete(true));
    }
  }
  return _completer!.future;
}
