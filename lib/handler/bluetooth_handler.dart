import 'dart:async' show Future, Stream;

import 'package:app_settings/app_settings.dart' show AppSettings;
import 'package:flutter_blue/flutter_blue.dart'
    show BluetoothCharacteristic, BluetoothDevice, BluetoothService, FlutterBlue, Guid;
import 'package:tendon_loader/handler/data_handler.dart' show DataHandler;
import 'package:tendon_support_lib/extensions.dart' show ExConvert;
import 'package:tendon_support_lib/tendon_support_lib.dart' show ExConvert, Progressor;
import 'package:tendon_support_module/modal/chartdata.dart' show ChartData;

class Bluetooth with DataHandler {
  static BluetoothDevice? _device;
  static BluetoothCharacteristic? _dataChar;
  static BluetoothCharacteristic? _controlChar;

  static Stream<bool>? get isConnecting => _device?.isDiscoveringServices;
  static bool get isConnected => _device != null && _dataChar != null && _controlChar != null;
  static String get deviceName => isConnected
      ? _device!.name.isEmpty
          ? _device!.id.id
          : _device!.name
      : 'Device Not Connected!';

  static Future<void> enable() async {
    _device = _dataChar = _controlChar = null;
    await AppSettings.openBluetoothSettings();
  }

  static Future<void> notify(bool value) async {
    if (isConnected) await _dataChar!.setNotifyValue(value);
  }

  static Future<void> startWeightMeas() async => _write(Progressor.cmdStartWeightMeasurement);

  static Future<void> stopWeightMeas() async => _write(Progressor.cmdStopWeightMeasuremnt);

  static Future<void> sleep() async => _write(Progressor.cmdEnterSleep);

  static Future<void> _write(int command) async {
    if (isConnected) {
      Future<void>.delayed(const Duration(milliseconds: 10), () async {
        await _controlChar!.write(<int>[command]);
        DataHandler.dataClear();
        minTime = 0;
      });
    }
  }

  static Future<void> startScan() async {
    await FlutterBlue.instance.startScan(
      timeout: const Duration(seconds: 2),
      withDevices: <Guid>[Guid(Progressor.uuidService)],
      withServices: <Guid>[Guid(Progressor.uuidService)],
    );
  }

  static Future<void> stopScan() async => FlutterBlue.instance.stopScan();

  static Future<void> connect(BluetoothDevice? device) async {
    if (!isConnected && device != null) {
      await (_device = device).connect(autoConnect: false);
      await _getProps();
    }
  }

  static Future<void> disconnect([BluetoothDevice? device]) async {
    await device?.disconnect();
    if (isConnected) {
      await _device?.disconnect();
      _device = _dataChar = _controlChar = null;
    }
  }

  static Future<void> _getProps() async {
    final List<BluetoothService> _services = await _device!.discoverServices();
    final BluetoothService _service =
        _services.firstWhere((BluetoothService s) => s.uuid == Guid(Progressor.uuidService));
    final List<BluetoothCharacteristic> _chars = _service.characteristics;
    _controlChar = _chars.firstWhere((BluetoothCharacteristic c) => c.uuid == Guid(Progressor.uuidControl));
    _dataChar = _chars.firstWhere((BluetoothCharacteristic c) => c.uuid == Guid(Progressor.uuidData));
    await notify(true);
    _listen();
  }

  // Data Listener
  static final List<ChartData> dataList = <ChartData>[];
  static double minTime = 0;

  static void _listen() {
    if (isConnected) {
      _dataChar!.value.listen((List<int> data) {
        if (data.isNotEmpty && data[0] == Progressor.resWeightMeasurement) {
          for (int x = 2; x < data.length; x += 8) {
            final double weight = data.getRange(x, x + 4).toList().toWeight;
            final double time = data.getRange(x + 4, x + 8).toList().toTime;
            if (time > minTime) {
              minTime = time;
              final ChartData element = ChartData(load: weight, time: time);
              dataList.add(element);
              DataHandler.dataSink.add(element);
            }
          }
        }
      });
    }
  }
}
