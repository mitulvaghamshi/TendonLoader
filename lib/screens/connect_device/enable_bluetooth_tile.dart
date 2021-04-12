import 'package:flutter/material.dart';
import 'package:tendon_loader/components/custom_button.dart';
import 'package:tendon_loader/components/custom_image.dart';
import 'package:tendon_loader/utils/app/constants.dart' show Descriptions, Images;
import 'package:tendon_loader/utils/controller/bluetooth.dart';

class EnableBluetoothTile extends StatelessWidget {
  const EnableBluetoothTile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: const <Widget>[
        CustomImage(name: Images.imgEnableBluetooth),
        Text(Descriptions.descEnableBluetooth, textAlign: TextAlign.center),
        SizedBox(height: 30),
        CustomButton(text: 'Enable', icon: Icons.bluetooth_rounded, onPressed: Bluetooth.enable),
      ],
    );
  }
}
