import 'package:bluetooth_enable/bluetooth_enable.dart';
import 'package:flutter_blue/flutter_blue.dart';

class Bluetooth {
  // UUIDs
  static final String _serviceUuid = "7e4e1701-1ea6-40c9-9dcc-13d34ffead57"; // main service
  static final String _controlPointUuid = "7e4e1703-1ea6-40c9-9dcc-13d34ffead57"; // send commands
  static final String _dataCharacteristicUuid = "7e4e1702-1ea6-40c9-9dcc-13d34ffead57"; // receive data

  // Responses
  static const int RES_CMD_RESPONSE = 0;
  static const int RES_WEIGHT_MEAS = 1;
  static const int RES_RFD_PEAK = 2;
  static const int RES_RFD_PEAK_SERIES = 3;
  static const int RES_LOW_PWR_WARNING = 4;

  // Commands
  static const int CMD_TARE_SCALE = 100;
  static const int CMD_START_WEIGHT_MEAS = 101;
  static const int CMD_STOP_WEIGHT_MEAS = 102;
  static const int CMD_START_PEAK_RFD_MEAS = 103;
  static const int CMD_START_PEAK_RFD_MEAS_SERIES = 104;
  static const int CMD_ADD_CALIBRATION_POINT = 105;
  static const int CMD_SAVE_CALIBRATION = 106;
  static const int CMD_GET_APP_VERSION = 107;
  static const int CMD_GET_ERROR_INFORMATION = 108;
  static const int CMD_CLR_ERROR_INFORMATION = 109;
  static const int CMD_ENTER_SLEEP = 110;
  static const int CMD_GET_BATTERY_VOLTAGE = 111;

  static BluetoothDevice _mDevice; // Connected device
  static BluetoothCharacteristic _mDataChar; // data receiver
  static BluetoothCharacteristic _mControlChar; // data controller

  const Bluetooth._();

  factory Bluetooth() => instance;

  static Bluetooth instance = Bluetooth._();

  static BluetoothDevice get device => _mDevice;

  void sleep() async => await write(CMD_ENTER_SLEEP);

  void setDevice(BluetoothDevice device) => _mDevice = device;

  void listen(Function listener) => _mDataChar?.value?.listen(listener);

  Future<void> startNotify() async => await _mDataChar?.setNotifyValue(true);

  Future<void> stopNotify() async => await _mDataChar?.setNotifyValue(false);

  Future<void> startWeightMeas() async => await write(CMD_START_WEIGHT_MEAS);

  Future<void> stopWeightMeas() async => await write(CMD_STOP_WEIGHT_MEAS);

  Future<void> write(int command) async => await _mControlChar?.write([command]);

  Future<void> enable() async => await BluetoothEnable.enableBluetooth;

  Future<void> stopScan() async => await FlutterBlue.instance.stopScan();

  Future<void> startScan() async {
    await FlutterBlue.instance.startScan(
      timeout: Duration(seconds: 3),
      withDevices: [Guid('7e4e1701-1ea6-40c9-9dcc-13d34ffead57')],
      withServices: [Guid('7e4e1701-1ea6-40c9-9dcc-13d34ffead57')],
    );
  }

  Future<void> disconnect() async {
    await device?.disconnect();
    // _mDevice = null;
  }

  Future<void> connect() async {
    await _mDevice?.connect(autoConnect: false);
    List<BluetoothService> services = await _mDevice?.discoverServices();
    BluetoothService service = services?.singleWhere((s) => s.uuid.toString() == _serviceUuid);
    List<BluetoothCharacteristic> chars = service?.characteristics;
    _mControlChar = chars?.singleWhere((c) => c.uuid.toString() == _controlPointUuid);
    _mDataChar = chars?.singleWhere((c) => c.uuid.toString() == _dataCharacteristicUuid);
  }
}
