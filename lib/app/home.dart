import 'package:flutter/material.dart';
import 'package:tendon_loader/app/device/connected_devices.dart';
import 'package:tendon_loader/app/exercise/new_exercise.dart';
import 'package:tendon_loader/app/handler/bluetooth_handler.dart';
import 'package:tendon_loader/app/handler/location_handler.dart';
import 'package:tendon_loader/app/livedata/live_data.dart';
import 'package:tendon_loader/app/mvctest/mvc_testing.dart';
import 'package:tendon_loader/shared/app_auth.dart';
import 'package:tendon_loader/shared/custom/custom_frame.dart';
import 'package:tendon_loader/shared/custom/custom_image.dart';
import 'package:tendon_loader/shared/custom/custom_listtile.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  static const String name = 'Tendon Loader';
  static const String route = '/home';

  @override
  _HomeState createState() => _HomeState();
}

enum ActionType { settings, export, about, close }

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    Locator.init();
    Bluetooth.reConnect();
  }

  @override
  void dispose() {
    Locator.dispose();
    AppAuth.signOut();
    Bluetooth.disconnect();
    super.dispose();
  }

  void _aboutDialog() {
    showAboutDialog(
      context: context,
      applicationVersion: 'v1.0',
      applicationName: Home.name,
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

  Future<void> _onSelected(ActionType type) async {
    switch (type) {
      case ActionType.about:
        return _aboutDialog();
      case ActionType.export:
        break;
      case ActionType.close:
        break;
      case ActionType.settings:
        break;
    }
  }

  @override
  Widget build(_) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Home.name),
        actions: <Widget>[
          PopupMenuButton<ActionType>(
            onSelected: _onSelected,
            icon: const Icon(Icons.more_vert_rounded),
            itemBuilder: (BuildContext context) => <PopupMenuItem<ActionType>>[
              const PopupMenuItem<ActionType>(value: ActionType.settings, child: Text('Settings')),
              const PopupMenuItem<ActionType>(value: ActionType.export, child: Text('Export')),
              const PopupMenuItem<ActionType>(value: ActionType.about, child: Text('About')),
              if (true) const PopupMenuItem<ActionType>(value: ActionType.close, child: Text('Exit')),
            ],
          ),
        ],
      ),
      body: AppFrame(
        isScrollable: true,
        child: Column(
          children: <Widget>[
            const CustomImage(isLogo: true),
            CustomTile(context: context, name: LiveData.name, route: LiveData.route, icon: Icons.show_chart_rounded),
            CustomTile(context: context, name: NewExercise.name, route: NewExercise.route, icon: Icons.directions_run_rounded),
            CustomTile(context: context, name: MVCTesting.name, route: MVCTesting.route, icon: Icons.airline_seat_legroom_extra),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Connect Device'),
        icon: const Icon(Icons.bluetooth_rounded),
        onPressed: () => showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            scrollable: true,
            content: const ConnectedDevices(),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text('Select Bluetooth Device', textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
}
