import 'dart:async' show Future, Stream, Timer;

import 'package:app_settings/app_settings.dart';
import 'package:flutter_blue/flutter_blue.dart'
    show BluetoothCharacteristic, BluetoothDevice, BluetoothService, FlutterBlue, Guid;
import 'package:tendon_loader/custom/extensions.dart';
import 'package:tendon_loader/handler/data_handler.dart' show clearGraphData, graphDataSink;
import 'package:tendon_loader_lib/tendon_loader_lib.dart';

BluetoothDevice? _device;
BluetoothCharacteristic? _dataChar;
BluetoothCharacteristic? _controlChar;

Stream<bool>? get isDeviceConnecting => _device?.isDiscoveringServices;
bool get isDeviceConnected => _device != null && _dataChar != null && _controlChar != null;
String get deviceName => isDeviceConnected
    ? _device!.name.isEmpty
        ? _device!.id.id
        : _device!.name
    : 'Device Not Connected!';

Future<void> openBluetoothSetting() async {
  _device = _dataChar = _controlChar = null;
  await AppSettings.openBluetoothSettings();
}

Future<void> setDataNotification(bool value) async {
  if (isDeviceConnected) await _dataChar!.setNotifyValue(value);
}

Future<void> startWeightMeasuring() async {
  if (!isDeviceRunning) {
    await _write(cmdStartWeightMeasurement);
    isDeviceRunning = true;
  }

  // fakelisten();
}

Future<void> stopWeightMeasuring() async {
  if (isDeviceRunning) {
    await _write(cmdStopWeightMeasuremnt);
    isDeviceRunning = false;
    lastMinTime = 0;
    clearGraphData();
  }

  // timer?.cancel();
  // clearGraphData();
}

Future<void> sleepDevice() async => _write(cmdEnterSleep);

Future<void> _write(int command) async {
  if (isDeviceConnected) {
    Future<void>.delayed(const Duration(milliseconds: 10), () async {
      await _controlChar!.write(<int>[command]);
    });
  }
}

Future<void> startDeviceScan() async {
  await FlutterBlue.instance.startScan(
    timeout: const Duration(seconds: 2),
    withDevices: <Guid>[Guid(uuidService)],
    withServices: <Guid>[Guid(uuidService)],
  );
}

Future<void> stopDeviceScan() async => FlutterBlue.instance.stopScan();

Future<void> connectDevice(BluetoothDevice? device) async {
  if (!isDeviceConnected && device != null) {
    await (_device = device).connect(autoConnect: false);
    await _getProps();
  }
}

Future<void> disconnectDevice([BluetoothDevice? device]) async {
  await device?.disconnect();
  if (isDeviceConnected) {
    await _device?.disconnect();
    _device = _dataChar = _controlChar = null;
  }
}

Future<void> _getProps() async {
  final List<BluetoothService> s = await _device!.discoverServices();
  for (int i = s.length - 1; i > 0 && (_controlChar == null || _dataChar == null); i--) {
    for (final BluetoothCharacteristic c in s[i].characteristics) {
      if (c.uuid == Guid(uuidControl)) {
        _controlChar = c;
      } else if (c.uuid == Guid(uuidData)) {
        _dataChar = c;
      }
    }
  }
  await setDataNotification(true);
  _listen();
}

double lastMinTime = 0;
bool isDeviceRunning = false;
final List<ChartData> exportDataList = <ChartData>[];

void _listen() {
  if (isDeviceConnected) {
    _dataChar!.value.listen((List<int> data) {
      if (isDeviceRunning && data.isNotEmpty && data[0] == resWeightMeasurement) {
        for (int x = 2; x < data.length; x += 8) {
          final double weight = data.getRange(x, x + 4).toList().toWeight;
          final double time = data.getRange(x + 4, x + 8).toList().toTime;
          if (time > lastMinTime) {
            lastMinTime = time;
            final ChartData element = ChartData(load: weight, time: time);
            exportDataList.add(element);
            graphDataSink.add(element);
          }
        }
      }
    });
  }
}

// late Timer? timer;
// void fakelisten() {
//   double fakeLoad = 0;
//   timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
//     final ChartData element = ChartData(load: fakeLoad += 1, time: timer.tick.toDouble());
//     exportDataList.add(element);
//     graphDataSink.add(element);
//     if (fakeLoad > 10) fakeLoad = 0;
//   });
// }
