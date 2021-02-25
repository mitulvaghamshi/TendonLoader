import 'package:bluetooth_enable/bluetooth_enable.dart';
import 'package:flutter_blue/flutter_blue.dart';

class Bluetooth {
  // UUIDs
  static final _serviceUuid = "7e4e1701-1ea6-40c9-9dcc-13d34ffead57"; // main service
  static final _dataCharacteristicUuid = "7e4e1702-1ea6-40c9-9dcc-13d34ffead57"; // receive data
  static final _controlPointUuid = "7e4e1703-1ea6-40c9-9dcc-13d34ffead57"; // send commands

  // Responses
  static const RES_CMD_RESPONSE = 0;
  static const RES_WEIGHT_MEAS = 1;
  static const RES_RFD_PEAK = 2;
  static const RES_RFD_PEAK_SERIES = 3;
  static const RES_LOW_PWR_WARNING = 4;

  // Commands
  static const CMD_TARE_SCALE = 100;
  static const CMD_START_WEIGHT_MEAS = 101;
  static const CMD_STOP_WEIGHT_MEAS = 102;
  static const CMD_START_PEAK_RFD_MEAS = 103;
  static const CMD_START_PEAK_RFD_MEAS_SERIES = 104;
  static const CMD_ADD_CALIBRATION_POINT = 105;
  static const CMD_SAVE_CALIBRATION = 106;
  static const CMD_GET_APP_VERSION = 107;
  static const CMD_GET_ERROR_INFORMATION = 108;
  static const CMD_CLR_ERROR_INFORMATION = 109;
  static const CMD_ENTER_SLEEP = 110;
  static const CMD_GET_BATTERY_VOLTAGE = 111;

  static BluetoothDevice _mDevice;

  static BluetoothCharacteristic _mDataCharacteristic;

  static BluetoothCharacteristic _mControlCharacteristic;

  static BluetoothDevice get device => _mDevice;

  factory Bluetooth() => instance;

  get startNotify async => await _mDataCharacteristic?.setNotifyValue(true);

  get stopNotify async => await _mDataCharacteristic?.setNotifyValue(false);

  get startWeightMeasurement async => await write(CMD_START_WEIGHT_MEAS);

  get stopWeightMeasurement async => await write(CMD_STOP_WEIGHT_MEAS);

  get sleep async => await write(CMD_ENTER_SLEEP);

  Bluetooth._();

  static Bluetooth instance = Bluetooth._();

  void setDevice(BluetoothDevice device) => _mDevice = device;

  void listen(Function listener) => _mDataCharacteristic?.value?.listen(listener);

  Future<void> write(int command) async => await _mControlCharacteristic?.write([command]);

  Future<void> enable() async => await BluetoothEnable.enableBluetooth;

  Future<void> disconnect() async => await Bluetooth.device?.disconnect();

  Future<void> stopScan() async => await FlutterBlue.instance.stopScan();

  Future<void> startScan() async {
    await FlutterBlue.instance.startScan(
      timeout: Duration(seconds: 3),
      withDevices: [Guid('7e4e1701-1ea6-40c9-9dcc-13d34ffead57')],
      withServices: [Guid('7e4e1701-1ea6-40c9-9dcc-13d34ffead57')],
    );
  }

  Future<void> connect() async {
    await _mDevice?.connect()?.then((_) async {
      await _mDevice.discoverServices().then((services) {
        return services?.singleWhere((service) {
          return service.uuid.toString() == _serviceUuid;
        });
      }).then((service) {
        return service?.characteristics;
      }).then((characteristics) {
        characteristics?.forEach((characteristic) {
          if (characteristic.uuid.toString() == _dataCharacteristicUuid) {
            _mDataCharacteristic = characteristic;
          } else if (characteristic.uuid.toString() == _controlPointUuid) {
            _mControlCharacteristic = characteristic;
          }
        });
      });
    });
  }
}
