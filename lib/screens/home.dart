import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/components/app_frame.dart';
import 'package:tendon_loader/components/custom_image.dart';
import 'package:tendon_loader/components/custom_listtile.dart';
import 'package:tendon_loader/screens/bluetooth/device_scanner.dart';
import 'package:tendon_loader/screens/exercise_mode/new_exercise.dart';
import 'package:tendon_loader/screens/live_data/live_data.dart';
import 'package:tendon_loader/screens/mvc_testing/mvc_testing.dart';
import 'package:tendon_loader/utils/app_auth.dart';
import 'package:tendon_loader/utils/bluetooth.dart';
import 'package:tendon_loader/utils/location.dart';

class Home extends StatefulWidget {
  const Home({Key/*?*/ key}) : super(key: key);

  static const String route = '/home';
  static const String name = 'Tendon Loader';

  @override
  _HomeState createState() => _HomeState();
}

enum ActionType {
  settings,
  export,
  about,
  close,
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    Locator.init();
    Bluetooth.reConnect();
  }

  @override
  void dispose() {
    AppAuth.signOut();
    Locator.dispose();
    Bluetooth.sleep();
    super.dispose();
  }

  void _onSelected(ActionType type) {
    switch (type) {
      case ActionType.about:
        return _aboutDialog();
      case ActionType.export:
        // TODO(mitul): Handle this case.
        break;
      case ActionType.close:
        // TODO(mitul): Handle this case.
        break;
      case ActionType.settings:
        // TODO(mitul): Handle this case.
        break;
    }
  }

  void _aboutDialog() {
    showAboutDialog(
      context: context,
      applicationVersion: 'v1.0',
      applicationName: Home.name,
      applicationLegalese: 'Application Legalese',
      applicationIcon: const CustomImage(isLogo: true, radius: 50),
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

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
          useSafeArea: true,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            scrollable: true,
            content: const DeviceScanner(),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text('Select Bluetooth Device', textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
}
