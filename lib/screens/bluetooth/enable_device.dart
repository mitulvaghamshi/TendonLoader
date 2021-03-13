import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:tendon_loader/components/custom_button.dart';
import 'package:tendon_loader/components/custom_image.dart';
import 'package:tendon_loader/utils/bluetooth.dart';
import 'package:tendon_loader/utils/location.dart' as loc;

class EnableDevice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CustomImage(name: 'enable_device.webp'),
        const Text(
          'Activate your device by pressing the button, then press scan to find the device',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),
        CustomButton(
          text: 'Scan',
          color: Colors.black,
          icon: Icons.search_rounded,
          onPressed: () async {
            bool _isEnabled = await Location.instance.serviceEnabled();
            if (_isEnabled) {
              await Bluetooth.instance.startScan();
              loc.Location.dispose();
            } else {
              loc.Location.sink.add(_isEnabled);
            }
          },
        ),
      ],
    );
  }
}
