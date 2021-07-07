import 'dart:async';
import 'dart:io';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/constants/progressor.dart';
import 'package:tendon_loader/handler/graph_data_handler.dart';
import 'package:tendon_loader/modal/chartdata.dart';
import 'package:tendon_loader/utils/extension.dart';

final List<ChartData> exportDataList = <ChartData>[];

double _lastMillis = 0;
bool _isRunning = false;
Completer<bool>? _completer;

BluetoothDevice? _device;
BluetoothCharacteristic? _dataChar;
BluetoothCharacteristic? _controlChar;

BluetoothDevice? get connectedDevice => _device;

String get deviceName => _device!.name.isEmpty ? _device!.id.id : _device!.name;

Future<void> setNotification(bool value) async => _dataChar!.setNotifyValue(value);

Future<void> sleepDevice() async => _controlChar!.write(<int>[cmdEnterSleep]);

Future<void> stopDeviceScan() async => FlutterBlue.instance.stopScan();

Future<void> startDeviceScan() async {
  await FlutterBlue.instance.startScan(
    timeout: const Duration(seconds: 2),
    withDevices: <Guid>[Guid(uuidService)],
    withServices: <Guid>[Guid(uuidService)],
  );
}

Future<void> startTaring() async {
  if (!_isRunning) {
    _isRunning = true;
    await _controlChar!.write(<int>[cmdStartWeightMeas]);
  }
}

Future<void> stopTaring() async {
  if (_isRunning) {
    _isRunning = false;
    await _controlChar!.write(<int>[cmdTareScale]);
    await _controlChar!.write(<int>[cmdStartWeightMeas]);
    await _controlChar!.write(<int>[cmdStopWeightMeas]);
    _lastMillis = 0;
    clearGraphData();
    exportDataList.clear();
  }
}

Future<void> startWeightMeas() async {
  if (!_isRunning) {
    if (simulateBT) {
      _fakeListen();
    } else {
      await _controlChar!.write(<int>[cmdStartWeightMeas]);
    }
    _isRunning = true;
  }
}

Future<void> stopWeightMeas() async {
  if (_isRunning) {
    if (simulateBT) {
      _timer?.cancel();
    } else {
      await _controlChar!.write(<int>[cmdStopWeightMeas]);
    }
    _isRunning = false;
    _lastMillis = 0;
    clearGraphData();
  }
}

Future<void> disconnectDevice() async {
  if (_device != null) {
    await _device!.disconnect();
    _device = _dataChar = _controlChar = null;
    _isRunning = false;
    _lastMillis = 0;
    clearGraphData();
    _completer = null;
    exportDataList.clear();
  }
}

Future<bool> getProps(BluetoothDevice device) async {
  if (_device != null && _dataChar != null && _controlChar != null) {
    return Future<void>.delayed(const Duration(milliseconds: 800), startTaring).then((_) => true);
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
    await setNotification(true);
    if (Platform.isAndroid) await device.requestMtu(120);
    if (_dataChar != null && _controlChar != null) {
      _addListener();
      _device = device;
      await Future<void>.delayed(const Duration(milliseconds: 800), startTaring).then((_) {
        _completer!.complete(true);
      });
    }
  }
  return _completer!.future;
}

void _addListener() {
  _dataChar!.value.listen((List<int> data) {
    if (_isRunning && data.isNotEmpty && data[0] == resWeightMeasurement) {
      for (int x = 2; x < data.length; x += 8) {
        final double weight = data.getRange(x, x + 4).toList().toWeight;
        final double time = data.getRange(x + 4, x + 8).toList().toTime;
        if (time > _lastMillis) {
          _lastMillis = time;
          final ChartData element = ChartData(load: weight, time: time);
          exportDataList.add(element);
          graphDataSink.add(element);
        }
      }
    }
  });
}

// simulator start
late Timer? _timer;
late bool simulateBT;

void _fakeListen() {
  double fakeLoad = 0;
  _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
    final ChartData element = ChartData(load: fakeLoad += 2, time: timer.tick.toDouble());
    exportDataList.add(element);
    graphDataSink.add(element);
    if (fakeLoad++ > 10) fakeLoad = 0;
  });
}
// simulator end
