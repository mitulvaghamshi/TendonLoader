import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/app/bluetooth/scanner_list.dart';
import 'package:tendon_loader/app/widgets/custom_tile.dart';

class ScanningTile extends StatelessWidget {
  const ScanningTile({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      initialData: false,
      stream: FlutterBlue.instance.isScanning,
      builder: (_, AsyncSnapshot<bool> snapshot) {
        if (snapshot.data!) {
          return const CustomTile(
            title: 'Scanning...',
            left: CircularProgressIndicator.adaptive(),
          );
        }
        return const ScannerList();
      },
    );
  }
}
