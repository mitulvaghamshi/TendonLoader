import 'package:flutter/material.dart';
import 'package:tendon_loader/constants/descriptions.dart';
import 'package:tendon_loader/custom/app_logo.dart';
import 'package:tendon_loader/device/tiles/bluetooth_tile.dart';
import 'package:tendon_loader/handler/bluetooth_handler.dart';
import 'package:tendon_loader/handler/graph_data_handler.dart';
import 'package:tendon_loader/handler/export_handler.dart';
import 'package:tendon_loader/handler/location_handler.dart';
import 'package:tendon_loader/homescreen.dart';
import 'package:tendon_loader/login/app_auth.dart';
 import 'package:wakelock/wakelock.dart';

Future<void> manualExport(BuildContext context) async {
  final int _records = await checkLocalData();
  if (_records > 0) {
    await tryUpload(context, _records);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('You have no local data available at this time!')),
    );
  }
}

Future<void> tryUpload(BuildContext context, int records) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      reSubmit();
      return AlertDialog(
        title: FittedBox(
          fit: BoxFit.fitWidth,
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: const <Widget>[
            Icon(Icons.cloud_upload, size: 50, color: Colors.green),
            Text('Uploading local data', textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
          ]),
        ),
        content: ExpansionTile(
          tilePadding: const EdgeInsets.all(5),
          title: Text('$records file${records == 1 ? '' : 's'} uploaded.'),
          subtitle: const Text('Tap for more info...', style: TextStyle(fontSize: 12)),
          leading: const Icon(Icons.check_circle_outline_rounded, size: 30, color: Colors.green),
          children: const <Widget>[Text(descUpload, style: TextStyle(fontSize: 12), textAlign: TextAlign.justify)],
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: <Widget>[TextButton(onPressed: Navigator.of(context).pop, child: const Text('OK'))],
      );
    },
  );
}

void aboutDialog(BuildContext context) {
  showAboutDialog(
    context: context,
    applicationVersion: 'v1.0',
    applicationName: HomeScreen.name,
    // applicationLegalese: 'Application Legalese',
    applicationIcon: const AppLogo(size: 50),
    children: <Widget>[
      const Text(
        'Tendon Loader :Preview',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.blue, fontSize: 18, fontFamily: 'Georgia'),
      ),
      // const SizedBox(height: 20),
      // const Text(
      //   'Mitul Vaghamshi',
      //   textAlign: TextAlign.center,
      //   style: TextStyle(color: Colors.blue, fontSize: 20, fontFamily: 'Georgia', letterSpacing: 1.5),
      // ),
      // const SizedBox(height: 20),
      // const Text('mitulvaghmashi@gmail.com', textAlign: TextAlign.center),
    ],
  );
}

Future<void> congratulate(BuildContext context) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return AlertDialog(
        title: FittedBox(
          fit: BoxFit.fitWidth,
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: const <Widget>[
            Icon(Icons.emoji_events_rounded, size: 50, color: Colors.green),
            Text('Congratulations!!!', textAlign: TextAlign.center, style: TextStyle(fontSize: 26)),
          ]),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: const Text(
          'Exercise session completed!\nGreat work!',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          TextButton.icon(
            label: const Text('Next'),
            icon: const Icon(Icons.arrow_forward),
            onPressed: Navigator.of(context).pop,
          ),
        ],
      );
    },
  );
}

Future<void> selectDevice(BuildContext context) async {
  await checkLocation();
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      scrollable: true,
      content: const BluetoothTile(),
      contentPadding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Select Bluetooth Device', textAlign: TextAlign.center),
      actions: <Widget>[TextButton(onPressed: () => Navigator.pop(context), child: const Text('Back'))],
    ),
  );
}

Future<void> tryAutoUpload(BuildContext context) async {
  Future<void>.delayed(const Duration(seconds: 2), () async {
    final int _records = await checkLocalData();
    if (_records > 0) await tryUpload(context, _records);
  });
}

Future<bool> onAppClose() async {
  await Wakelock.disable();
  await disconnectDevice();
  await signOut();
  disposeLocationHandler();
  disposeGraphData();
  return true;
}
