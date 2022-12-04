import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/common/widgets/loading_widget.dart';
import 'package:tendon_loader/screens/bluetooth/scanner_list.dart';

/// This class is constantly listening to Scanning status using
/// [FlutterBlue.instance.isScanning] stream until this widget
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
      builder: (_, AsyncSnapshot<bool> snapshot) {
        // If Scanning in progress... Show Loading...
        if (snapshot.data!) return const LoadingWidget();
        // else, Move to Scanner list which shows devices from scan result.
        return const ScannerList();
      },
    );
  }
}
