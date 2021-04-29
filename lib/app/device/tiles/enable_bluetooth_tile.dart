import 'package:flutter/material.dart';
import 'package:tendon_loader/app/handler/bluetooth_handler.dart';
import 'package:tendon_loader/shared/constants.dart';
import 'package:tendon_loader/shared/custom/custom_button.dart';
import 'package:tendon_loader/shared/custom/custom_image.dart';

class EnableBluetoothTile extends StatelessWidget {
  const EnableBluetoothTile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const CustomImage(name: Images.IMG_ENABLE_BLUETOOTH),
        const Text(Descriptions.DESC_ENABLE_BLUETOOTH, textAlign: TextAlign.center),
        const SizedBox(height: 30),
        CustomButton(
          text: 'Enable',
          icon: Icons.bluetooth_rounded,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enable manually!')));
            /*Bluetooth.enable*/
          },
        ),
      ],
    );
  }
}
