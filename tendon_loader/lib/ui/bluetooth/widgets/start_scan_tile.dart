import 'package:flutter/material.dart';
import 'package:tendon_loader/handlers/bluetooth_handler.dart';
import 'package:tendon_loader/ui/bluetooth/widgets/image_widget.dart';
import 'package:tendon_loader/ui/widgets/raw_button.dart';
import 'package:tendon_loader/utils/constants.dart';

/// This class, when loaded, prompts user to (Turn on / Power on)
/// the "Progressor" device, they are trying to connect to.
/// Once, device is powred on, user can use "Scan" button
/// to start scanning for nearby device.
@immutable
final class StartScanTile extends StatelessWidget with Progressor {
  const StartScanTile({super.key});

  @override
  Widget build(BuildContext context) {
    // A visual content to guid user to power on the "Progressor" device.
    // and start scanning after...
    return Column(mainAxisSize: MainAxisSize.min, children: [
      const ImageWidget(path: Images.enableDevice),
      const Text(
        Strings.enableDevice,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      RawButton.tile(
        leading: const Icon(Icons.search),
        onTap: startScan,
        child: const Text('Scan'),
      ),
    ]);
  }
}
