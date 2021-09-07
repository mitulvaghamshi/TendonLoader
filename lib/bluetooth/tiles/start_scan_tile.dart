/// Author: Mitul Vaghamshi
/// Email: mitulvaghmashi@gmail.com

import 'package:flutter/material.dart';
import 'package:tendon_loader/bluetooth/device_handler.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_image.dart';
import 'package:tendon_loader/utils/constants.dart';

class StartScanTile extends StatelessWidget {
  const StartScanTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: const <Widget>[
      CustomImage(name: imgEnableDevice),
      Text(
        descEnableDevice,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      CustomButton(
        left: Icon(Icons.search),
        onPressed: startScan,
        right: Text('Scan'),
      ),
    ]);
  }
}
