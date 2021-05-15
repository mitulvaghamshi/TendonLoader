import 'package:flutter/material.dart';
import 'package:tendon_loader/app/handler/bluetooth_handler.dart';
import 'package:tendon_loader/shared/constants.dart';
import 'package:tendon_loader/shared/custom/custom_button.dart';
import 'package:tendon_loader/shared/custom/custom_image.dart';

class StartScanTile extends StatelessWidget {
  const StartScanTile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: const <Widget>[
        CustomImage(name: Images.IMG_ENABLE_DEVICE),
        Text(Descriptions.DESC_ENABLE_DEVICE, textAlign: TextAlign.center),
        SizedBox(height: 30),
        CustomButton(
            text: 'Scan',
            icon: Icons.search_rounded,
            onPressed: Bluetooth.startScan),
      ],
    );
  }
}
