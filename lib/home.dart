import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_listtile.dart';
import 'package:tendon_loader/device/tiles/bluetooth_tile.dart';
import 'package:tendon_loader/exercise/new_exercise.dart';
import 'package:tendon_loader/handler/bluetooth_handler.dart';
import 'package:tendon_loader/handler/data_handler.dart';
import 'package:tendon_loader/handler/export_handler.dart';
import 'package:tendon_loader/handler/location_handler.dart';
import 'package:tendon_loader/livedata/live_data.dart';
import 'package:tendon_loader/login/app_auth.dart';
import 'package:tendon_loader/login/login.dart';
import 'package:tendon_loader/mvctest/new_mvc_test.dart';
import 'package:tendon_loader/settings/app_settings.dart';
import 'package:tendon_loader_lib/tendon_loader_lib.dart';
import 'package:wakelock/wakelock.dart';

enum ActionType { settings, export, about, logout }

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  static const String route = '/home';
  static const String name = 'Tendon Loader';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    checkLocation();
    Wakelock.enable();
    WidgetsBinding.instance!.addObserver(this);
    Future<void>.delayed(const Duration(seconds: 2), () async {
      final int _records = await checkLocalData();
      if (_records > 0) await _tryUpload(_records);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) checkLocation();
  }

  void _aboutDialog() {
    showAboutDialog(
      context: context,
      applicationVersion: 'v1.0',
      applicationName: Home.name,
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

  Future<void> _tryUpload(int records) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        reExport();
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

  void _connectDevice() {
    checkLocation();
    showDialog<void>(
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

  Future<void> _onSelected(ActionType type) async {
    switch (type) {
      case ActionType.about:
        return _aboutDialog();
      case ActionType.export:
        await _manualExport();
        break;
      case ActionType.logout:
        await signOut();
        await Navigator.pushReplacementNamed(context, Login.route);
        break;
      case ActionType.settings:
        await Navigator.pushNamed(context, AppSettings.route);
        break;
    }
  }

  Future<void> _manualExport() async {
    final int _records = await checkLocalData();
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
        const PopupMenuItem<ActionType>(value: ActionType.export, child: Text('Export')),
        const PopupMenuItem<ActionType>(value: ActionType.about, child: Text('About')),
        const PopupMenuItem<ActionType>(value: ActionType.logout, child: Text('Logout')),
      ],
    );
  }

  void _handleTap(String route) => isDeviceConnected || true ? Navigator.pushNamed(context, route) : _connectDevice();

  @override
  Widget build(BuildContext context) {
    print('home build...');
    return Scaffold(
      appBar: AppBar(title: const Text(Home.name), actions: <Widget>[_buildMenu()]),
      body: SingleChildScrollView(
        child: AppFrame(
          onExit: () async {
            await Wakelock.disable();
            await disconnectDevice();
            await signOut();
            disposeLocationHandler();
            disposeGraphData();
            return true;
          },
          child: Column(
            children: <Widget>[
              const AppLogo(),
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
                title: NewMVCTest.name,
                onTap: () => _handleTap(NewMVCTest.route),
                icon: const Icon(Icons.airline_seat_legroom_extra, size: 30),
              ),
            ],
          ),
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
