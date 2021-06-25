import 'package:flutter/material.dart';
import 'package:tendon_loader/constants/descriptions.dart';
import 'package:tendon_loader/constants/images.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_image.dart';
import 'package:tendon_loader/handler/bluetooth_handler.dart';

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
        CustomButton(
          icon: Icon(Icons.bluetooth_rounded),
          onPressed: openBluetoothSetting,
          child: Text('Open Settings'),
        ),
      ],
    );
  }
}
