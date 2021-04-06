import 'package:bluetooth_enable/bluetooth_enable.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/utils/constants.dart' show Progressor;

mixin Bluetooth {
  static BluetoothDevice _device; // Connected device
  static BluetoothCharacteristic _dataChar; // data receiver
  static BluetoothCharacteristic _controlChar; // data controller

  static BluetoothDevice get device => _device;

  static String get deviceName => _device?.name ?? _device?.id.toString();

  static void listen(void Function(List<int>) listener) {
    _dataChar?.value?.listen(listener);
  }

  static Future<void> enable() async {
    //todo(mitul): not supported by iOS
    await BluetoothEnable.enableBluetooth;
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
    await _controlChar?.write(<int>[command]);
  }

  static Future<void> disconnect() async {
    await _device?.disconnect();
    _device = _dataChar = _controlChar = null;
  }

  static Future<void> startScan() async {
    await FlutterBlue.instance.startScan(
      timeout: const Duration(seconds: 1),
      withDevices: <Guid>[Guid(Progressor.serviceUuid)],
      withServices: <Guid>[Guid(Progressor.serviceUuid)],
    );
  }

  static Future<void> connect(BluetoothDevice device) async {
    await device.connect(autoConnect: false);
    await getProps(device);
  }

  static Future<void> reConnect() async {
    final List<BluetoothDevice> devices = await FlutterBlue.instance.connectedDevices;
    devices?.forEach(getProps);
  }

  static Future<void> getProps(BluetoothDevice device) async {
    _device = device;
    final List<BluetoothService> services = await _device?.discoverServices();
    final BluetoothService service = services?.singleWhere((BluetoothService s) => s.uuid.toString() == Progressor.serviceUuid);
    final List<BluetoothCharacteristic> chars = service?.characteristics;
    _controlChar = chars?.singleWhere((BluetoothCharacteristic c) => c.uuid.toString() == Progressor.controlPointUuid);
    _dataChar = chars?.singleWhere((BluetoothCharacteristic c) => c.uuid.toString() == Progressor.dataCharacteristicUuid);
  }
}
