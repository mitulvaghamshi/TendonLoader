import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_image.dart';
import 'package:tendon_loader/handler/location_handler.dart';
import 'package:tendon_loader_lib/tendon_loader_lib.dart';

class EnableLocationTile extends StatelessWidget {
  const EnableLocationTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: const <Widget>[
        CustomImage(name: imgEnableLocation),
        Text(
          descLocationLine1,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Text(descLocationLine2, textAlign: TextAlign.center, style: TextStyle(fontSize: 14)),
        SizedBox(height: 15),
        Text(
          descLocationLine3,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
        ),
        SizedBox(height: 30),
        CustomButton(text: 'Open Settings', icon: Icons.location_on_rounded, onPressed: enableLocation),
      ],
    );
  }
}
