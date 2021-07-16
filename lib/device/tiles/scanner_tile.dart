import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/custom/custom_progress.dart';
import 'package:tendon_loader/device/scanner_list.dart';

class ScannerTile extends StatelessWidget {
  const ScannerTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      initialData: false,
      stream: FlutterBlue.instance.isScanning,
      builder: (_, AsyncSnapshot<bool> snapshot) {
        return snapshot.data! ? const CustomProgress(text: 'Scanning...') : const ScannerList();
      },
    );
  }
}
