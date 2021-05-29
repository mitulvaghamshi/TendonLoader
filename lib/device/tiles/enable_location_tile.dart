import 'package:flutter/material.dart';
import 'package:tendon_loader/handler/location_handler.dart';
import 'package:tendon_support_lib/tendon_support_lib.dart' show CustomButton, CustomImage, Images, Descriptions;

class EnableLocationTile extends StatelessWidget {
  const EnableLocationTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: const <Widget>[
        CustomImage(name: Images.imgEnableLocation),
        Text(
          Descriptions.descLocationLine1,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Text(Descriptions.descLocationLine2, textAlign: TextAlign.center, style: TextStyle(fontSize: 14)),
        SizedBox(height: 15),
        Text(
          Descriptions.descLocationLine3,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
        ),
        SizedBox(height: 30),
        CustomButton(text: 'Open Settings', icon: Icons.location_on_rounded, onPressed: Locator.enable),
      ],
    );
  }
}
