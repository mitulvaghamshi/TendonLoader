import 'package:flutter_blue/flutter_blue.dart';

class BluetoothArgs {
  final BluetoothDevice device;
  final BluetoothCharacteristic mDataCharacteristic;
  final BluetoothCharacteristic mControlCharacteristic;

  BluetoothArgs({this.device, this.mDataCharacteristic, this.mControlCharacteristic});
}
