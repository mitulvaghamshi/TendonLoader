import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/shared/constants.dart';

enum BTActions {
  ENABLE,
  DISABLE,

  CONNECT,
  DISCONNECT,

  START_SCAN,
  STOP_SCAN,

  START_NOTIFY,
  STOP_NOTIFY,

  START_WEIGHT_MEAS,
  STOP_WEIGHT_MEAS,

  LISTEN,

  SLEEP,
}

mixin Bluetooth {
  static BluetoothDevice _device;
  static BluetoothCharacteristic _dataChar;
  static BluetoothCharacteristic _controlChar;

  static BluetoothDevice get device => _device;

  static String get deviceName => _device?.name ?? _device?.id.toString();

  static bool isConnected = false;

  static Future<void> perform(BTActions actions) async {
    if (isConnected) {
      switch (actions) {
        case BTActions.ENABLE:
          break;
        case BTActions.DISABLE:
          // TODO: Handle this case.
          break;
        case BTActions.CONNECT:
          // TODO: Handle this case.
          break;
        case BTActions.DISCONNECT:
          // TODO: Handle this case.
          break;
        case BTActions.START_SCAN:
          // TODO: Handle this case.
          break;
        case BTActions.STOP_SCAN:
          // TODO: Handle this case.
          break;
        case BTActions.START_NOTIFY:
          // TODO: Handle this case.
          break;
        case BTActions.STOP_NOTIFY:
          // TODO: Handle this case.
          break;
        case BTActions.START_WEIGHT_MEAS:
          // TODO: Handle this case.
          break;
        case BTActions.STOP_WEIGHT_MEAS:
          // TODO: Handle this case.
          break;
        case BTActions.LISTEN:
          // TODO: Handle this case.
          break;
        case BTActions.SLEEP:
          // TODO: Handle this case.
          break;
      }
    }
  }

  static void listen(void Function(List<int>) listener) {
    _dataChar.value.listen(listener);
  }

  static Future<void> enable() async {
    await AppSettings.openBluetoothSettings();
  }

  static Future<void> stopScan() async {
    await FlutterBlue.instance.stopScan();
  }

  static Future<void> stopNotify() async {
    await _dataChar.setNotifyValue(false);
  }

  static Future<void> startNotify() async {
    await _dataChar.setNotifyValue(true);
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
      await _controlChar.write(<int>[command]);
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
    );
  }

  static Future<void> connect(BluetoothDevice device) async {
    await device.connect(autoConnect: false);
    await getProps(device);
  }

  static Future<void> reConnect() async => (await FlutterBlue.instance.connectedDevices).forEach(getProps);

  static Future<void> getProps(BluetoothDevice device) async {
    _device = device;
    final List<BluetoothService> services = await _device.discoverServices();
    final BluetoothService service =
        services.firstWhere((BluetoothService s) => s.uuid == Guid(Progressor.SERVICE_UUID));
    final List<BluetoothCharacteristic> chars = service.characteristics;
    _controlChar = chars.firstWhere((BluetoothCharacteristic c) => c.uuid == Guid(Progressor.CONTROL_POINT_UUID));
    _dataChar = chars.firstWhere((BluetoothCharacteristic c) => c.uuid == Guid(Progressor.DATA_CHARACTERISTICS_UUID));
    isConnected = true;
    await startNotify();
  }
}
