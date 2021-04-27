import 'dart:async';
import 'dart:io';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart' show FlutterBluetoothSerial;
import 'package:tendon_loader/shared/constants.dart';

mixin Bluetooth {
  static BluetoothDevice _device; // Connected device
  static BluetoothCharacteristic _dataChar; // data receiver
  static BluetoothCharacteristic _controlChar; // data controller

  static BluetoothDevice get device => _device;

  static String get deviceName => _device?.name ?? _device?.id.toString();

  static bool isConnected = false;

  static void listen(void Function(List<int>) listener) {
    _dataChar?.value?.listen(listener);
  }

  static Future<void> enable() async {
    if (Platform.isIOS) {
      await FlutterBluetoothSerial.instance.openSettings();
    } else {
      await FlutterBluetoothSerial.instance.requestEnable();
    }
  }

  static Future<void> stopScan() async {
    await FlutterBlue.instance.stopScan();
  }

  static Future<void> stopNotify() async {
    await _dataChar?.setNotifyValue(false);
  }

  static Future<void> startNotify() async {
    await _dataChar?.setNotifyValue(true);
  }

  static Future<void> stopWeightMeas() async {
    await write(Progressor.CMD_STOP_WEIGHT_MEAS);
  }

  static Future<void> startWeightMeas() async {
    await write(Progressor.CMD_START_WEIGHT_MEAS);
  }

  static Future<void> sleep() async {
    await write(Progressor.CMD_ENTER_SLEEP);
  }

  static Future<void> write(int command) async {
    Future<void>.delayed(const Duration(milliseconds: 50), () async {
      await _controlChar?.write(<int>[command]);
    });
  }

  static Future<void> disconnect() async {
    await _device?.disconnect();
    isConnected = false;
    _device = _dataChar = _controlChar = null;
  }

  static Future<void> startScan() async {
    await FlutterBlue.instance.startScan(
      timeout: const Duration(seconds: 3),
      withDevices: <Guid>[Guid(Progressor.SERVICE_UUID)],
      withServices: <Guid>[Guid(Progressor.SERVICE_UUID)],
    );
  }

  static Future<void> connect(BluetoothDevice device) async {
    await device.connect(autoConnect: false);
    await getProps(device);
  }

  static Future<void> reConnect() async => (await FlutterBlue.instance.connectedDevices).forEach(getProps);

  static Future<void> getProps(BluetoothDevice device) async {
    _device = device;
    await startNotify();
    final List<BluetoothService> services = await _device?.discoverServices();
    final BluetoothService service = services?.singleWhere((BluetoothService s) => s.uuid.toString() == Progressor.SERVICE_UUID);
    final List<BluetoothCharacteristic> chars = service?.characteristics;
    _controlChar = chars?.singleWhere((BluetoothCharacteristic c) => c.uuid.toString() == Progressor.CONTROL_POINT_UUID);
    _dataChar = chars?.singleWhere((BluetoothCharacteristic c) => c.uuid.toString() == Progressor.DATA_CHARACTERISTICS_UUID);
    isConnected = true;
  }
}
