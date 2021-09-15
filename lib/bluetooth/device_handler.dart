/// MIT License
/// 
/// Copyright (c) 2021 Mitul Vaghamshi
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in all
/// copies or substantial portions of the Software.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.

import 'dart:async';
import 'dart:io';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/screens/graph/graph_handler.dart';
import 'package:tendon_loader/utils/constants.dart';

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
  await FlutterBlue.instance.startScan(timeout: const Duration(seconds: 2));
}

Future<void> tareProgressor() async {
  if (_isRunning) {
    _isRunning = false;
    await _controlChar!.write(<int>[cmdTareScale]);
    await _controlChar!.write(<int>[cmdStartWeightMeas]);
    await _controlChar!.write(<int>[cmdStopWeightMeas]);
  }
}

Future<void> startWeightMeas() async {
  if (!_isRunning) {
    _isRunning = true;
    await _controlChar!.write(<int>[cmdStartWeightMeas]);
  }
}

Future<void> stopWeightMeas() async {
  if (_isRunning) {
    _isRunning = false;
    await _controlChar!.write(<int>[cmdStopWeightMeas]);
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
