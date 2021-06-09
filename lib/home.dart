import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_listtile.dart';
import 'package:tendon_loader/exercise/new_exercise.dart';
import 'package:tendon_loader/handler/bluetooth_handler.dart';
import 'package:tendon_loader/handler/location_handler.dart';
import 'package:tendon_loader/handler/dialog_handler.dart';
import 'package:tendon_loader/livedata/live_data.dart';
import 'package:tendon_loader/mvctest/new_mvc_test.dart';
import 'package:tendon_loader/settings/app_settings.dart';
import 'package:tendon_loader_lib/tendon_loader_lib.dart';
import 'package:wakelock/wakelock.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  static const String name = 'Tendon Loader';
  static const String route = '/home';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    tryAutoUpload(context);
    Wakelock.enable();
    checkLocation();
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

  void _handleTap(String route) =>
      isDeviceConnected || true ? Navigator.pushNamed(context, route) : selectDevice(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(Home.name), actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.settings_rounded),
          onPressed: () async => Navigator.pushNamed(context, AppSettings.route),
        ),
      ]),
      body: SingleChildScrollView(
        child: AppFrame(
          onExit: onAppClose,
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
        onPressed: () async => selectDevice(context),
        label: const Text('Connect Device'),
        icon: const Icon(Icons.bluetooth_rounded),
      ),
    );
  }
}
