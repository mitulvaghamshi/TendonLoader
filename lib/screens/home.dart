import 'package:flutter/material.dart';
<<<<<<< Updated upstream
import 'package:flutter_blue/flutter_blue.dart';
=======
import 'package:tendon_loader/components/app_frame.dart';
>>>>>>> Stashed changes
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

  static const String routeName = '/home';
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
    FlutterBlue.instance?.connectedDevices?.then((List<BluetoothDevice> value) => value?.forEach(Bluetooth.instance?.init));
  }

  @override
  void dispose() {
<<<<<<< Updated upstream
    Bluetooth.instance?.sleep();
=======
    AppAuth.signOut();
>>>>>>> Stashed changes
    Locator.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Home.name),
        actions: <Widget>[
          PopupMenuButton<ActionType>(
            icon: const Icon(Icons.more_vert_rounded),
            onSelected: (ActionType type) {
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
            },
            itemBuilder: (BuildContext context) => <PopupMenuItem<ActionType>>[
              const PopupMenuItem<ActionType>(value: ActionType.settings, child: Text('Settings')),
              const PopupMenuItem<ActionType>(value: ActionType.export, child: Text('Export')),
              const PopupMenuItem<ActionType>(value: ActionType.about, child: Text('About')),
              if (true) const PopupMenuItem<ActionType>(value: ActionType.close, child: Text('Exit')),
            ],
          ),
        ],
      ),
<<<<<<< Updated upstream
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 16,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const CustomImage(scale: 0.7),
                CustomTile(context: context, name: LiveData.name, route: LiveData.routeName, icon: Icons.show_chart_rounded),
                CustomTile(context: context, name: NewExercise.name, route: NewExercise.routeName, icon: Icons.directions_run_rounded),
                CustomTile(context: context, name: MVCTesting.name, route: MVCTesting.routeName, icon: Icons.airline_seat_legroom_extra),
              ],
            ),
          ),
=======
      body: AppFrame(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const CustomImage(isLogo: true),
            CustomTile(context: context, name: LiveData.name, route: LiveData.route, icon: Icons.show_chart_rounded),
            CustomTile(context: context, name: NewExercise.name, route: NewExercise.route, icon: Icons.directions_run_rounded),
            CustomTile(context: context, name: MVCTesting.name, route: MVCTesting.route, icon: Icons.airline_seat_legroom_extra),
          ],
>>>>>>> Stashed changes
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
            title: const Text('Select Bluetooth Device', textAlign: TextAlign.center),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
      ),
    );
  }

  void _aboutDialog() {
    showAboutDialog(
      context: context,
      applicationVersion: 'v1.0',
      applicationName: Home.name,
      applicationLegalese: 'Application Legalese',
      applicationIcon: const CustomImage(
        scale: 0.25,
      ),
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
}
