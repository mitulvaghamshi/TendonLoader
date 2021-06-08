import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_image.dart';
import 'package:tendon_loader/handler/bluetooth_handler.dart';
import 'package:tendon_loader_lib/tendon_loader_lib.dart';

class EnableBluetoothTile extends StatelessWidget {
  const EnableBluetoothTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: const <Widget>[
        CustomImage(name: keyEnableBluetooth),
        Text(descEnableBluetooth, textAlign: TextAlign.center),
        SizedBox(height: 30),
        CustomButton(text: 'Open Settings', icon: Icons.bluetooth_rounded, onPressed: openBluetoothSetting),
      ],
    );
  }
}
