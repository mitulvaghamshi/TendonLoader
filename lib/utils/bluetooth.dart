import 'package:bluetooth_enable/bluetooth_enable.dart';
import 'package:flutter_blue/flutter_blue.dart';

class Bluetooth {
  factory Bluetooth() => instance;

  const Bluetooth._();

  // UUIDs
  static const String _serviceUuid = '7e4e1701-1ea6-40c9-9dcc-13d34ffead57'; // main service
  static const String _controlPointUuid = '7e4e1703-1ea6-40c9-9dcc-13d34ffead57'; // send commands
  static const String _dataCharacteristicUuid = '7e4e1702-1ea6-40c9-9dcc-13d34ffead57'; // receive data

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

  static BluetoothDevice/*?*/ _device; // Connected device
  static BluetoothCharacteristic/*?*/ _dataChar; // data receiver
  static BluetoothCharacteristic/*?*/ _controlChar; // data controller

  static bool _isBusy = false;
  static bool _isWorking = false;

  bool get waiting => _isBusy || _isWorking;

  static Bluetooth instance = const Bluetooth._();

  static BluetoothDevice/*?*/ get device => _device;

  void reset() {
    _device = _dataChar = _controlChar = null;
    _isBusy = false;
  }

  void listen(void Function(List<int> _data) listener) => _dataChar?.value?.listen(listener);

  Future<void> enable() async {
    if (!_isBusy) {
      _isBusy = true;
      await BluetoothEnable.enableBluetooth.then((_) => _isBusy = false);
    }
  }

  Future<void> stopScan() async {
    if (!_isBusy) {
      _isBusy = true;
      await FlutterBlue.instance.stopScan().then((dynamic value) => _isBusy = false);
    }
  }

  Future<void> stopNotify() async {
    if (!_isBusy) {
      _isBusy = true;
      await _dataChar?.setNotifyValue(false)?.then((_) => _isBusy = false);
    }
  }

  Future<void> startNotify() async {
    if (!_isBusy) {
      _isBusy = true;
      await _dataChar?.setNotifyValue(true)?.then((_) => _isBusy = false);
    }
  }

  Future<void> stopWeightMeas() async {
    if (_isWorking) {
      _isWorking = false;
      await write(CMD_STOP_WEIGHT_MEAS);
    }
  }

  Future<void> startWeightMeas() async {
    if (!_isWorking) {
      _isWorking = true;
      await write(CMD_START_WEIGHT_MEAS);
    }
  }

  Future<void> sleep() async {
    await write(CMD_ENTER_SLEEP).then((_) => reset());
  }

  Future<void> write(int command) async {
    if (!_isBusy) {
      _isBusy = true;
      await _controlChar?.write(<int>[command])?.then((_) => _isBusy = false);
    }
  }

  Future<void> disconnect() async {
    if (!_isBusy) {
      _isBusy = true;
      await _device?.disconnect()?.then((dynamic _) => reset());
    }
  }

  Future<void> startScan() async {
    await FlutterBlue.instance.startScan(
      timeout: const Duration(seconds: 1),
      withDevices: <Guid>[Guid(_serviceUuid)],
      withServices: <Guid>[Guid(_serviceUuid)],
    ).then((dynamic _) => _isBusy = false);
  }

  Future<void> connect(BluetoothDevice device) async {
    await device?.connect(autoConnect: false)?.then((_) async => init(device))?.then((_) => _isBusy = false);
  }

  Future<void> init(BluetoothDevice device) async {
    _device = device;
    final List<BluetoothService> services = await device?.discoverServices();
    final BluetoothService service = services?.singleWhere((BluetoothService s) => s.uuid.toString() == _serviceUuid);
    final List<BluetoothCharacteristic> chars = service?.characteristics;
    _controlChar = chars?.singleWhere((BluetoothCharacteristic c) => c.uuid.toString() == _controlPointUuid);
    _dataChar = chars?.singleWhere((BluetoothCharacteristic c) => c.uuid.toString() == _dataCharacteristicUuid);
  }
}
