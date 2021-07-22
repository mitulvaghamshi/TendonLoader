import 'package:flutter/material.dart';
import 'package:tendon_loader/utils/constant/descriptions.dart';
import 'package:tendon_loader/utils/constant/images.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_image.dart';
import 'package:tendon_loader/handlers/device_handler.dart';

class ProgressorTile extends StatelessWidget {
  const ProgressorTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: const <Widget>[
      CustomImage(name: imgEnableDevice),
      Text(
        descEnableDevice,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      CustomButton(icon: Icon(Icons.search), onPressed: startScan, child: Text('Scan')),
    ]);
  }
}
