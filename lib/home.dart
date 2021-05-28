import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart' show SvgPicture;
import 'package:hive/hive.dart' show Hive;
import 'package:tendon_loader/device/tiles/bluetooth_tile.dart' show BluetoothTile;
import 'package:tendon_loader/exercise/new_exercise.dart' show NewExercise;
import 'package:tendon_loader/handler/bluetooth_handler.dart' show Bluetooth;
import 'package:tendon_loader/handler/data_handler.dart' show DataHandler;
import 'package:tendon_loader/handler/export_handler.dart' show ExportHandler;
import 'package:tendon_loader/handler/location_handler.dart' show Locator;
import 'package:tendon_loader/livedata/live_data.dart' show LiveData;
import 'package:tendon_loader/mvctest/mvc_testing.dart' show MVCTesting;
import 'package:tendon_support_lib/tendon_support_lib.dart' show AppFrame, AppLogo, CustomTile, Images, Descriptions;
import 'package:tendon_support_module/app_auth.dart' show AppAuth;
import 'package:tendon_support_module/login/login.dart' show Login;
import 'package:wakelock/wakelock.dart' show Wakelock;

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
    Locator.check();
    WidgetsBinding.instance!.addObserver(this);
    Future<void>.delayed(const Duration(seconds: 2), () async {
      final int _records = await ExportHandler.checkLocalData();
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
    if (state == AppLifecycleState.resumed) Locator.check();
  }

  void _aboutDialog() {
    showAboutDialog(
      context: context,
      applicationVersion: 'v1.0',
      applicationName: Home.name,
      // applicationLegalese: 'Application Legalese',
      applicationIcon: SvgPicture.asset(Images.imgAppLogo, height: 50, width: 50),
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
        ExportHandler.reExport();
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const <Widget>[
              Icon(Icons.cloud_upload, size: 30, color: Colors.green),
              Text('Uploading local data', textAlign: TextAlign.center),
            ],
          ),
          content: ExpansionTile(
            subtitle: const Text('Tap for more info...'),
            title: Text('$records file${records == 1 ? '' : 's'} uploaded.'),
            leading: const Icon(Icons.check_circle_outline_rounded, size: 30, color: Colors.green),
            children: const <Widget>[Text(Descriptions.descUpload)],
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          actions: <Widget>[TextButton(onPressed: Navigator.of(context).pop, child: const Text('OK'))],
        );
      },
    );
  }

  void _connectDevice() {
    Locator.check();
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
        await AppAuth.signOut();
        await Navigator.pushReplacementNamed(context, Login.route);
        break;
      case ActionType.settings:
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Available soon...')));
        break;
    }
  }

  Future<void> _manualExport() async {
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
        const PopupMenuItem<ActionType>(value: ActionType.logout, child: Text('Logout')),
      ],
    );
  }

  void _handleTap(String route) =>
      Bluetooth.isConnected || true ? Navigator.pushNamed(context, route) : _connectDevice();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(Home.name), actions: <Widget>[_buildMenu()]),
      body: SingleChildScrollView(
        child: AppFrame(
          onExit: () async {
            await Wakelock.disable();
            await Bluetooth.disconnect();
            await AppAuth.signOut();
            await Hive.close();
            Locator.dispose();
            DataHandler.dataDispose();
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
                title: MVCTesting.name,
                onTap: () => _handleTap(MVCTesting.route),
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
