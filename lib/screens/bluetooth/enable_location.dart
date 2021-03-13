import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:tendon_loader/components/custom_button.dart';
import 'package:tendon_loader/components/custom_image.dart';
import 'package:tendon_loader/utils/location.dart' as loc;

class EnableLocation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CustomImage(name: 'enable_location.webp'),
        const Text(
          'This app uses bluetooth to communicate with your Progressor.',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        const Text(
          'Scanning for bluetooth devices can be used to locate you. That\'s why we ask you to permit location services. We\'re only using this permission to scan for your Progressor.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 15),
        const Text(
          'We\'ll never collect your physical location.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
        ),
        const SizedBox(height: 30),
        CustomButton(
          text: 'Enable',
          color: Colors.black,
          icon: Icons.location_on_rounded,
          onPressed: () async => loc.Location.sink.add(await Location.instance.requestService()),
        ),
      ],
    );
  }
}
