import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import 'package:tendon_loader/ui/bluetooth/widgets/image_widget.dart';
import 'package:tendon_loader/ui/bluetooth/widgets/start_scan_tile.dart';
import 'package:tendon_loader/ui/widgets/raw_button.dart';
import 'package:tendon_loader/utils/constants.dart';

/// This class, when loaded, prompts user to (Enable / Turn on / Allow access)
/// to the Location Services (GPS), on this device.
/// User can use "Open Settings" button to enable location services, it will
/// take user to device specific Location Settings screen,
/// where user have to manually torn on the service.
/// Alternatively, user can user "Control Center" to do the same.
@immutable
final class LocationTile extends StatelessWidget {
  const LocationTile({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: Stream<bool>.periodic(const Duration(milliseconds: 300))
          .asyncMap((_) async => loc.Location().serviceEnabled()),
      builder: (_, snapshot) {
        // If the location access is allowed,
        // check if "The Progressor" is powered on...
        if (snapshot.hasData && snapshot.data!) return const StartScanTile();
        // A visual content to inform user about location services and privacy.
        return Column(mainAxisSize: MainAxisSize.min, children: [
          const ImageWidget(path: Images.enableLocation),
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
          RawButton.tile(
            leading: const Icon(Icons.location_on_rounded),
            child: const Text('Open Settings'),
            onTap: () => AppSettings.openAppSettings(
              type: AppSettingsType.location,
            ),
          ),
        ]);
      },
    );
  }
}
