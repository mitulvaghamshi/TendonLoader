import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/components/custom_button.dart';
import 'package:tendon_loader/screens/connect_device/device_tile.dart';
import 'package:tendon_loader/utils/app/constants.dart' show Descriptions;

class DeviceList extends StatelessWidget {
  const DeviceList({Key key, this.results, this.devices}) : super(key: key);

  final List<ScanResult> results;
  final List<BluetoothDevice> devices;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Text(Descriptions.DESC_CLICK_TO_CONNECT, textAlign: TextAlign.center),
        const SizedBox(height: 10),
        if (results != null) ...results.map((ScanResult result) => DeviceTile(device: result.device)),
        if (devices != null) ...devices.map((BluetoothDevice device) => DeviceTile(device: device)),
        const SizedBox(height: 10),
        CustomButton(text: 'Close', icon: Icons.cancel_rounded, onPressed: Navigator.of(context).pop),
      ],
    );
  }
}
