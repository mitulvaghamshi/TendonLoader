import 'package:app_settings/app_settings.dart' as ast;
import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import 'package:tendon_loader/common/constants.dart';
import 'package:tendon_loader/common/widgets/custom_widget.dart';
import 'package:tendon_loader/common/widgets/image_widget.dart';
import 'package:tendon_loader/screens/bluetooth/widgets/start_scan_tile.dart';

/// This class, when loaded, prompts user to (Enable / Turn on / Allow access)
/// to the Location Services (GPS), on this device.
/// User can use "Open Settings" button to enable location services, it will
/// take user to device specific Location Settings screen,
/// where user have to manually torn on the service.
/// Alternatively, user can user "Control Center" to do the same.
class LocationTile extends StatelessWidget {
  const LocationTile({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: Stream<bool>.periodic(const Duration(milliseconds: 300))
          .asyncMap((_) async => loc.Location().serviceEnabled()),
      builder: (_, AsyncSnapshot<bool> snapshot) {
        // If the location access is allowed,
        // check if "The Progressor" is powered on...
        if (snapshot.hasData && snapshot.data!) return const StartScanTile();
        // A visual content to inform user about location services and privacy.
        return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          const ImageWidget(name: Images.enableLocation),
          const Text(
            Strings.locationLine1,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const Text(
            Strings.locationLine2,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
          ),
          CustomWidget.two(
            left: const Icon(Icons.location_on_rounded),
            right: const Text('Open Settings'),
            onPressed: ast.AppSettings.openLocationSettings,
          ),
        ]);
      },
    );
  }
}
