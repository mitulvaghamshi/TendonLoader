import 'package:flutter/material.dart';
import 'package:tendon_loader/handler/bluetooth_handler.dart';
import 'package:tendon_loader/pages/bluetooth/widgets/image_widget.dart';
import 'package:tendon_loader/pages/widgets/button_factory.dart';
import 'package:tendon_loader/utils/constants.dart';

/// This class, when loaded, prompts user to (Turn on / Power on)
/// the "Progressor" device, they are trying to connect to.
/// Once, device is powred on, user can use "Scan" button
/// to start scanning for nearby device.
@immutable
class const StartScanTile({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: .min,
    children: [
      const ImageWidget(path: Images.enableDevice),
      const Text(
        Strings.enableDevice,
        textAlign: .center,
        style: .new(fontSize: 14, fontWeight: .w500),
      ),
      ButtonFactory.tile(
        onTap: Progressor.instance.scan,
        leading: const Icon(Icons.search),
        child: const Text('Scan'),
      ),
    ],
  );
}
