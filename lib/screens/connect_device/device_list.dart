import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/components/custom_button.dart';
import 'package:tendon_loader/screens/connect_device/device_tile.dart';
import 'package:tendon_loader/utils/constants.dart' show Descriptions;

class DeviceList extends StatelessWidget {
  const DeviceList({Key key, this.results = const <ScanResult>[], this.devices = const <BluetoothDevice>[]}) : super(key: key);

  final List<ScanResult> results;
  final List<BluetoothDevice> devices;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Text(Descriptions.descClickToConnect, textAlign: TextAlign.center),
        const SizedBox(height: 20),
        ...results.map((ScanResult result) => DeviceTile(device: result.device)),
        ...devices.map((BluetoothDevice device) => DeviceTile(device: device)),
        const SizedBox(height: 20),
        CustomButton(text: 'Close', icon: Icons.cancel, onPressed: () => Navigator.pop<void>(context)),
      ],
    );
  }
}
