import 'dart:typed_data';

import 'data.dart';

/// This will uses data from (data.dart file)
/// to perform conversation on received data.
/// the actual implementation is little bit different
/// with developer friendly way using some features provided by dart lang.,
/// the underlaying logic remains same as below.
void main() {
  const CMD_GET_APP_VERSION = 107;
  const CMD_GET_ERROR_INFORMATION = 108;
  const CMD_GET_BATTERY_VOLTAGE = 111;
  const RES_CMD_RESPONSE = 0;
  const RES_WEIGHT_MEAS = 1;
  const RES_LOW_PWR_WARNING = 4;

  int command = 0;

  for (List<int> data in dataList) {
    if (data[0] == RES_WEIGHT_MEAS) {
      // value 1 = weight measurement
      print('Payload size: ${data[1]}');
      for (int x = 2; x < data.length; x += 8) {
        // Weight
        Uint8List value = Uint8List.fromList(data.getRange(x, x + 4).toList());
        double weight = value.buffer.asByteData().getFloat32(0, Endian.little);
        // Time
        Uint8List timestamp = Uint8List.fromList(data.getRange(x + 4, x + 4 + 4).toList());
        int uSeconds = timestamp.buffer.asByteData().getUint32(0, Endian.little);
        // print
        print('$weight Kg, ${uSeconds / 1000000.0} Sec.');
      }
    } else if (data[0] == RES_LOW_PWR_WARNING) {
      print("Received low battery warning.");
    } else if (data[0] == RES_CMD_RESPONSE) {
      if (command == CMD_GET_APP_VERSION) {
        print('FW version: ${String.fromCharCodes(data.getRange(2, data.length))}');
      } else if (command == CMD_GET_BATTERY_VOLTAGE) {
        Uint8List value = Uint8List.fromList(data.getRange(2, data.length).toList());
        int voltage = value.buffer.asByteData().getUint32(0, Endian.little);
        print('Battery voltage: {$voltage} [mV]');
      } else if (command == CMD_GET_ERROR_INFORMATION) {
        print('Crashlog: ${String.fromCharCodes(data.getRange(2, data.length))}');
      }
    }
  }
}
