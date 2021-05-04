import 'package:flutter/material.dart';
import 'package:tendon_loader/app/handler/location_handler.dart';
import 'package:tendon_loader/shared/constants.dart';
import 'package:tendon_loader/shared/custom/custom_button.dart';
import 'package:tendon_loader/shared/custom/custom_image.dart';

class EnableLocationTile extends StatelessWidget {
  const EnableLocationTile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: const <Widget>[
        CustomImage(name: Images.IMG_ENABLE_LOCATION),
        Text(Descriptions.DESC_LOCATION_1, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 20),
        Text(Descriptions.DESC_LOCATION_2, textAlign: TextAlign.center, style: TextStyle(fontSize: 14)),
        SizedBox(height: 15),
        Text(Descriptions.DESC_LOCATION_3, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic)),
        SizedBox(height: 30),
        CustomButton(text: 'Enable', icon: Icons.location_on_rounded, onPressed: Locator.enable),
      ],
    );
  }
}
