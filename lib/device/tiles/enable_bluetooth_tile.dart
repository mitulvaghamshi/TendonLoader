import 'package:flutter/material.dart';
import 'package:tendon_loader/handler/bluetooth_handler.dart' show Bluetooth;
import 'package:tendon_support_lib/tendon_support_lib.dart' show CustomButton, CustomImage, Images, Descriptions;

class EnableBluetoothTile extends StatelessWidget {
  const EnableBluetoothTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: const <Widget>[
        CustomImage(name: Images.keyEnableBluetooth),
        Text(Descriptions.descEnableBluetooth, textAlign: TextAlign.center),
        SizedBox(height: 30),
        CustomButton(text: 'Open Settings', icon: Icons.bluetooth_rounded, onPressed: Bluetooth.enable),
      ],
    );
  }
}
