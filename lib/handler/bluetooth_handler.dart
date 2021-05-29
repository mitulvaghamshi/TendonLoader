import 'dart:async' show Future, Stream;

import 'package:app_settings/app_settings.dart';
import 'package:flutter_blue/flutter_blue.dart'
    show BluetoothCharacteristic, BluetoothDevice, BluetoothService, FlutterBlue, Guid;
import 'package:tendon_loader/handler/data_handler.dart' show clearGraphData, graphDataSink;
import 'package:tendon_support_lib/tendon_support_lib.dart' show ExConvert, Progressor;
import 'package:tendon_support_module/modal/chartdata.dart';

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
  isDeviceRunning = true;
  await _write(Progressor.cmdStartWeightMeasurement);
}

Future<void> stopWeightMeasuring() async {
  isDeviceRunning = false;
  await _write(Progressor.cmdStopWeightMeasuremnt);
}

Future<void> sleepDevice() async => _write(Progressor.cmdEnterSleep);

Future<void> _write(int command) async {
  if (isDeviceConnected) {
    Future<void>.delayed(const Duration(milliseconds: 10), () async {
      await _controlChar!.write(<int>[command]);
      clearGraphData();
      lastMinTime = 0;
    });
  }
}

Future<void> startDeviceScan() async {
  await FlutterBlue.instance.startScan(
    timeout: const Duration(seconds: 2),
    withDevices: <Guid>[Guid(Progressor.uuidService)],
    withServices: <Guid>[Guid(Progressor.uuidService)],
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
  final List<BluetoothService> _services = await _device!.discoverServices();
  final BluetoothService _service =
      _services.firstWhere((BluetoothService s) => s.uuid == Guid(Progressor.uuidService));
  final List<BluetoothCharacteristic> _chars = _service.characteristics;
  _controlChar = _chars.firstWhere((BluetoothCharacteristic c) => c.uuid == Guid(Progressor.uuidControl));
  _dataChar = _chars.firstWhere((BluetoothCharacteristic c) => c.uuid == Guid(Progressor.uuidData));
  await setDataNotification(true);
  _listen();
}

// Data Listener
final List<ChartData> exportDataList = <ChartData>[];
double lastMinTime = 0;
bool isDeviceRunning = false;

void _listen() {
  if (isDeviceConnected) {
    _dataChar!.value.listen((List<int> data) {
      if (isDeviceRunning && data.isNotEmpty && data[0] == Progressor.resWeightMeasurement) {
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
