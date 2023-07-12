import 'package:flutter/material.dart';
import 'package:tendon_loader/common/constants.dart';
import 'package:tendon_loader/common/widgets/image_widget.dart';
import 'package:tendon_loader/common/widgets/raw_button.dart';
import 'package:tendon_loader/screens/bluetooth/models/bluetooth_handler.dart';

/// This class, when loaded, prompts user to (Turn on / Power on)
/// the "Progressor" device, they are trying to connect to.
/// Once, device is powred on, user can use "Scan" button
/// to start scanning for nearby device.
class StartScanTile extends StatelessWidget with Progressor {
  const StartScanTile({super.key});

  @override
  Widget build(BuildContext context) {
    // A visual content to guid user to power on the "Progressor" device.
    // and start scanning after...
    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      const ImageWidget(path: Images.enableDevice),
      const Text(
        Strings.enableDevice,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      RawButton.icon(
        left: const Icon(Icons.search),
        right: const Text('Scan'),
        onTap: startScan,
      ),
    ]);
  }
}
