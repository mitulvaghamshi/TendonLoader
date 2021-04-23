import 'package:flutter/material.dart';
import 'package:tendon_loader/app/device/enable_location_tile.dart';
import 'package:tendon_loader/app/device/scan_result_tile.dart';
import 'package:tendon_loader/app/handler/location_handler.dart';

class LocationTile extends StatelessWidget {
  const LocationTile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      initialData: false,
      stream: Locator.stream,
      builder: (_, AsyncSnapshot<bool> snapshot) => snapshot.data ? const ScanResultTile() : const EnableLocationTile(),
    );
  }
}
