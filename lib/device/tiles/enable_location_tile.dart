import 'package:flutter/material.dart';
import 'package:tendon_loader/constants/descriptions.dart';
import 'package:tendon_loader/constants/images.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_image.dart';
import 'package:tendon_loader/handler/location_handler.dart';

class EnableLocationTile extends StatelessWidget {
  const EnableLocationTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: const <Widget>[
      CustomImage(name: imgEnableLocation),
      Text(
        descLocationLine1,
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 10),
      Text(
        descLocationLine2,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12),
      ),
      SizedBox(height: 10),
      Text(
        descLocationLine3,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
      ),
      SizedBox(height: 30),
      CustomButton(
        icon: Icon(Icons.location_on_rounded),
        onPressed: enableLocation,
        child: Text('Open Settings'),
      ),
    ]);
  }
}
