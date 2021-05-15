import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tendon_loader/app/custom/custom_listtile.dart';
import 'package:tendon_loader/app/device/connected_devices.dart';
import 'package:tendon_loader/app/exercise/exercise_mode.dart';
import 'package:tendon_loader/app/exercise/new_exercise.dart';
import 'package:tendon_loader/app/handler/bluetooth_handler.dart';
import 'package:tendon_loader/app/handler/export_handler.dart';
import 'package:tendon_loader/app/handler/location_handler.dart';
import 'package:tendon_loader/app/livedata/live_data.dart';
import 'package:tendon_loader/app/mvctest/mvc_testing.dart';
import 'package:tendon_loader/shared/app_auth.dart';
import 'package:tendon_loader/shared/custom/custom_frame.dart';
import 'package:tendon_loader/shared/custom/custom_image.dart';

enum ActionType { settings, export, about, close }

class AppHome extends StatefulWidget {
  const AppHome({Key key}) : super(key: key);

  static const String name = 'Tendon Loader';

  @override
  _AppHomeState createState() => _AppHomeState();

  static _AppHomeState of(BuildContext context) => context.findAncestorStateOfType<_AppHomeState>();
}

class _AppHomeState extends State<AppHome> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    Locator.check();
    Bluetooth.refresh();
    WidgetsBinding.instance.addObserver(this);
    Future<void>.delayed(const Duration(seconds: 2), () async {
      final int _records = await ExportHandler.checkLocalData();
      if (_records > 0) await _tryUpload(_records);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    Hive.close();
    Locator.dispose();
    AppAuth.signOut();
    Bluetooth.disconnect();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        Locator.check();
        Bluetooth.notify(true);
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        Bluetooth.notify(false);
        break;
    }
  }

  void _aboutDialog() {
    showAboutDialog(
      context: context,
      applicationVersion: 'v1.0',
      applicationName: AppHome.name,
      applicationLegalese: 'Application Legalese',
      applicationIcon: const CustomImage(radius: 50),
      children: <Widget>[
        const SizedBox(height: 20),
        const Text(
          '♥ Mitul Vaghamshi',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.blue, fontSize: 20, fontFamily: 'Georgia', letterSpacing: 1.5),
        ),
        const SizedBox(height: 20),
        const Text('✉ mitulvaghmashi@gmail.com', textAlign: TextAlign.center),
      ],
    );
  }

  Future<void> _tryUpload(int records) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        ExportHandler.reExport();
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              const Icon(Icons.cloud_upload, size: 30, color: Colors.green),
              Text('Uploading $records local file${records == 1 ? '' : 's'}.', textAlign: TextAlign.center),
            ],
          ),
          content: const Text(
            'To prevent accidental data loss,\n'
            'we are uploading locally stored data to the cloud.\n\n'
            'Please stay connected to the internet.\n\n'
            'You can continue using the app.',
            style: TextStyle(fontSize: 14),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          actions: <Widget>[TextButton(onPressed: Navigator.of(context).pop, child: const Text('OK'))],
        );
      },
    );
  }

  void _connectDevice() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        scrollable: true,
        content: const ConnectedDevices(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Select Bluetooth Device', textAlign: TextAlign.center),
      ),
    );
  }

  Future<void> _onSelected(ActionType type) async {
    switch (type) {
      case ActionType.about:
        // return _aboutDialog();
        break;
      case ActionType.export:
        await _manuallyExport();
        break;
      case ActionType.close:
        break;
      case ActionType.settings:
        break;
    }
  }

  Future<void> _manuallyExport() async {
    final int _records = await ExportHandler.checkLocalData();
    if (_records > 0) {
      await _tryUpload(_records);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You have no local data available at this time!')),
      );
    }
  }

  PopupMenuButton<ActionType> _buildMenu() {
    return PopupMenuButton<ActionType>(
      onSelected: _onSelected,
      icon: const Icon(Icons.more_vert_rounded),
      itemBuilder: (BuildContext context) => <PopupMenuItem<ActionType>>[
        const PopupMenuItem<ActionType>(value: ActionType.settings, child: Text('Settings')),
        const PopupMenuItem<ActionType>(value: ActionType.export, child: Text('Export All')),
        const PopupMenuItem<ActionType>(value: ActionType.about, child: Text('About')),
      ],
    );
  }

  void _handleTap(String route) =>
      Bluetooth.isConnected || true ? Navigator.pushNamed(context, route) : _connectDevice();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppHome.name), actions: <Widget>[_buildMenu()]),
      body: AppFrame(
        isScrollable: true,
        child: Column(
          children: <Widget>[
            const CustomImage(isLogo: true),
            CustomTile(
              title: LiveData.name,
              onTap: () => _handleTap(LiveData.route),
              icon: const Icon(Icons.show_chart_rounded, size: 30),
            ),
            CustomTile(
              title: NewExercise.name,
              onTap: () => _handleTap(NewExercise.route),
              icon: const Icon(Icons.directions_run_rounded, size: 30),
            ),
            CustomTile(
              title: MVCTesting.name,
              onTap: () => _handleTap(MVCTesting.route),
              icon: const Icon(Icons.airline_seat_legroom_extra, size: 30),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _connectDevice,
        label: const Text('Connect Device'),
        icon: const Icon(Icons.bluetooth_rounded),
      ),
    );
  }
}
