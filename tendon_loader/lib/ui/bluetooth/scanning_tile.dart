import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/ui/bluetooth/scanner_list.dart';
import 'package:tendon_loader/ui/widgets/button_factory.dart';

/// This class is constantly listening to Scanning status using
/// [FlutterBlue.instance].isScanning stream until this widget
/// is disposed.
/// This is repeating process...
/// No interactive content in this widget.
class ScanningTile extends StatelessWidget {
  const ScanningTile({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      initialData: false,
      stream: FlutterBlue.instance.isScanning,
      builder: (context, snapshot) {
        // If Scanning in progress... Show Loading...
        if (snapshot.data!) return const ButtonFactory.loading();
        // else, Move to Scanner list which shows devices from scan result.
        return const ScannerList();
      },
    );
  }
}
