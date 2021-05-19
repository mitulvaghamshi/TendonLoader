import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:hive/hive.dart';
import 'package:tendon_loader/shared/constants.dart';

mixin Bluetooth {
  static bool isConnected = false;

  static BluetoothDevice _device;
  static BluetoothCharacteristic _dataChar;
  static BluetoothCharacteristic _controlChar;

  static String get deviceName => isConnected ? _device.name ?? _device.id.toString() : 'Device Not Connected!';

  static Future<void> enable() async {
    _device = _dataChar = _controlChar = null;
    isConnected = false;
    await AppSettings.openBluetoothSettings();
  }

  static void listen(void Function(List<int>) listener) {
    if (isConnected) _dataChar.value.listen(listener);
  }

  static Future<void> notify(bool value) async {
    if (isConnected) await _dataChar.setNotifyValue(value);
  }

  static Future<void> startWeightMeas() async => _write(Progressor.CMD_START_WEIGHT_MEAS);

  static Future<void> stopWeightMeas() async => _write(Progressor.CMD_STOP_WEIGHT_MEAS);

  static Future<void> sleep() async => _write(Progressor.CMD_ENTER_SLEEP);

  static Future<void> _write(int command) async {
    if (isConnected) {
      Future<void>.delayed(const Duration(milliseconds: 20), () async => _controlChar.write(<int>[command]));
    }
  }

  static Future<void> startScan() async {
    await FlutterBlue.instance.startScan(
      timeout: const Duration(seconds: 3),
      withDevices: <Guid>[Guid(Progressor.SERVICE_UUID)],
      withServices: <Guid>[Guid(Progressor.SERVICE_UUID)],
    );
  }

  static Future<void> stopScan() async => FlutterBlue.instance.stopScan();

  static Future<void> refresh() async {
    final List<BluetoothDevice> _connected = await FlutterBlue.instance.connectedDevices;
    final String _deviceId = (Hive.box<String>(Keys.KEY_BT_DEVICE)).get(Keys.KEY_BT_DEVICE);
    if (_connected != null && _connected.isNotEmpty) {
      final BluetoothDevice device = _connected?.firstWhere((BluetoothDevice device) => device.id.id == _deviceId);
      if (device != null) await reConnect(device);
    }
  }

  static Future<void> reConnect(BluetoothDevice device) async {
    await disconnect(device);
    await connect(device);
  }

  static Future<void> connect(BluetoothDevice device) async {
    await (_device = device).connect(autoConnect: true);
    await _getProps();
  }

  static Future<void> disconnect([BluetoothDevice device]) async {
    await (device ?? _device)?.disconnect();
    _device = _dataChar = _controlChar = null;
    isConnected = false;
  }

  static Future<void> _getProps() async {
    final List<BluetoothService> _services = await _device?.discoverServices();
    final BluetoothService _service =
        _services?.firstWhere((BluetoothService s) => s.uuid == Guid(Progressor.SERVICE_UUID));
    final List<BluetoothCharacteristic> chars = _service?.characteristics;
    _dataChar = chars?.firstWhere((BluetoothCharacteristic c) => c.uuid == Guid(Progressor.DATA_CHARACTERISTICS_UUID));
    _controlChar = chars?.firstWhere((BluetoothCharacteristic c) => c.uuid == Guid(Progressor.CONTROL_POINT_UUID));
    isConnected = _dataChar != null && _controlChar != null;
    await (Hive.box<String>(Keys.KEY_BT_DEVICE)).put(Keys.KEY_BT_DEVICE, _device.id.id);
    await notify(true);
  }
}
