import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/pages/bluetooth/scanner_list.dart';
import 'package:tendon_loader/pages/widgets/button_factory.dart';

/// This class is constantly listening to Scanning status using
/// [FlutterBlue.instance].isScanning stream until this widget
/// is disposed.
/// This is repeating process...
/// No interactive content in this widget.
@immutable
class const ScanningTile({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => StreamBuilder(
    stream: FlutterBlue.instance.isScanning,
    initialData: false,
    // If Scanning in progress... Show Loading...
    // else, Move to Scanner list which shows devices from scan result.
    builder: (context, snapshot) =>
        snapshot.data! ? const ButtonFactory.loading() : const ScannerList(),
  );
}
