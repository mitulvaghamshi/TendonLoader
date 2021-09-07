/// Author: Mitul Vaghamshi
/// Email: mitulvaghmashi@gmail.com

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/bluetooth/lists/scanner_list.dart';
import 'package:tendon_loader/custom/progress_tile.dart';

class ScanningTile extends StatelessWidget {
  const ScanningTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      initialData: false,
      stream: FlutterBlue.instance.isScanning,
      builder: (_, AsyncSnapshot<bool> snapshot) {
        return snapshot.data!
            ? const CustomProgress(text: 'Scanning...')
            : const ScannerList();
      },
    );
  }
}
