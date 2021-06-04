import 'package:flutter/material.dart';
import 'package:tendon_loader/device/scanner_tile.dart';
import 'package:tendon_loader/device/tiles/enable_location_tile.dart';
import 'package:tendon_loader/handler/location_handler.dart';

class LocationTile extends StatelessWidget {
  const LocationTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      initialData: false,
      stream: LocationHandler.stream,
      builder: (_, AsyncSnapshot<bool> snapshot) {
        return snapshot.data! ? const ScannerTile() : const EnableLocationTile();
      },
    );
  }
}
