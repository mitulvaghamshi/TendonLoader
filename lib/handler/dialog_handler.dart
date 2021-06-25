import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tendon_loader/utils/themes.dart';
import 'package:tendon_loader/constants/descriptions.dart';
import 'package:tendon_loader/constants/keys.dart';
import 'package:tendon_loader/custom/app_logo.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/device/tiles/bluetooth_tile.dart';
import 'package:tendon_loader/handler/app_auth.dart';
import 'package:tendon_loader/handler/bluetooth_handler.dart';
import 'package:tendon_loader/handler/graph_data_handler.dart';
import 'package:tendon_loader/handler/location_handler.dart';
import 'package:tendon_loader/homescreen.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:wakelock/wakelock.dart';

Future<bool> submit(BuildContext context, Export export, bool later) async {
  late bool result;

  if (!later && await isConnected()) {
    result = await export.upload(context);
  } else {
    await Hive.box<Export>(keyExportBox).add(export);
    result = true;
  }
  return Future<bool>.value(result);
}

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

Future<void> tryAutoUpload(BuildContext context) async {
  Future<void>.delayed(const Duration(seconds: 2), () async {
    final int _records = await checkLocalData();
    if (_records > 0) await tryUpload(context, _records);
  });
}

Future<bool> isConnected() async => (await Connectivity().checkConnectivity()) != ConnectivityResult.none;

Future<int> checkLocalData() async {
  return await isConnected() ? Hive.box<Export>(keyExportBox).length : 0;
}

Future<bool?> reSubmit(BuildContext context) async {
  late bool? result;
  if (await isConnected()) {
    final Box<Export> _exportsBox = Hive.box(keyExportBox);
    for (final Export export in _exportsBox.values) {
      result = await export.upload(context);
      if (result) await export.delete();
    }
  }
  return Future<bool>.value(result);
}

Future<void> tryUpload(BuildContext context, int records) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      reSubmit(context);
      return AlertDialog(
        title: FittedBox(
          fit: BoxFit.fitWidth,
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: const <Widget>[
            Icon(Icons.cloud_upload, size: 50, color: googleGreen),
            Text('Uploading local data', textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
          ]),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: <Widget>[TextButton(onPressed: Navigator.of(context).pop, child: const Text('OK'))],
        content: ExpansionTile(
          tilePadding: const EdgeInsets.all(5),
          title: Text('$records file${records == 1 ? '' : 's'} uploaded.'),
          subtitle: const Text('Tap for more info...', style: TextStyle(fontSize: 12)),
          leading: const Icon(Icons.check_circle_outline_rounded, size: 30, color: googleGreen),
          children: const <Widget>[Text(descUpload, style: TextStyle(fontSize: 12), textAlign: TextAlign.justify)],
        ),
      );
    },
  );
}

Future<void> selectDevice(BuildContext context) async {
  await checkLocation();
  await showDialog<void>(
    context: context,
    builder: (_) => AlertDialog(
      scrollable: true,
      content: const BluetoothTile(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Select Bluetooth Device', textAlign: TextAlign.center),
    ),
  );
}

Future<bool> onAppClose() async {
  await Wakelock.disable();
  await disconnectDevice();
  await signOut();
  disposeLocationHandler();
  disposeGraphData();
  return true;
}

void navigateTo(BuildContext context, String route) {
  isDeviceConnected || true ? Navigator.pushNamed(context, route) : selectDevice(context);
}

void aboutDialog(BuildContext context) {
  showAboutDialog(
    context: context,
    applicationVersion: 'v1.0',
    applicationName: HomeScreen.name,
    // applicationLegalese: 'Application Legalese',
    applicationIcon: const AppLogo(radius: 30),
    children: <Widget>[
      const Text(
        'Tendon Loader :Preview',
        textAlign: TextAlign.center,
        style: TextStyle(color: googleGreen, fontSize: 18, fontFamily: 'Georgia'),
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
            Icon(Icons.emoji_events_rounded, size: 50, color: googleGreen),
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
          CustomButton(
            reverce: true,
            onPressed: Navigator.of(context).pop,
            icon: const Icon(Icons.arrow_forward, color: googleGreen),
            child: const Text('Next', style: TextStyle(color: googleGreen)),
          ),
        ],
      );
    },
  );
}
