import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/components/custom_image.dart';
import 'package:tendon_loader/components/custom_listtile.dart';
import 'package:tendon_loader/screens/bluetooth/device_scanner.dart';
import 'package:tendon_loader/screens/exercise_mode/new_exercise.dart';
import 'package:tendon_loader/screens/live_data/live_data.dart';
import 'package:tendon_loader/screens/mvc_testing/mvc_testing.dart';
import 'package:tendon_loader/utils/app_routes.dart';
import 'package:tendon_loader/utils/bluetooth.dart';
import 'package:tendon_loader/utils/location.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  static const String routeName = '/homepage';
  static const String name = 'Tendon Loader';

  @override
  _HomePageState createState() => _HomePageState();
}

enum ActionType {
  export,
  about,
  close,
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    FlutterBlue.instance?.connectedDevices?.then((List<BluetoothDevice> value) => value?.forEach(Bluetooth.instance?.init));
  }

  @override
  void dispose() {
    Bluetooth.instance?.sleep();
    Locator.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(HomePage.name),
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.info_outline_rounded), onPressed: aboutDialog),
          PopupMenuButton<ActionType>(
            icon: const Icon(Icons.add),
            onSelected: (ActionType type) {
              if (type == ActionType.export) Navigator.push<void>(context, getRouteByName());
            },
            itemBuilder: (BuildContext context) => <PopupMenuItem<ActionType>>[
              const PopupMenuItem<ActionType>(value: ActionType.export, child: Text('Export All')),
              const PopupMenuItem<ActionType>(value: ActionType.about, child: Text('About')),
              if (true) const PopupMenuItem<ActionType>(value: ActionType.close, child: Text('Exit')),
            ],
          ),
        ],
      ),
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
                const CustomImage(name: 'ic_launcher-playstore.png', scale: 0.7),
                CustomTile(
                  context: context,
                  name: LiveData.name,
                  route: LiveData.routeName,
                  icon: Icons.show_chart_rounded,
                ),
                CustomTile(
                  context: context,
                  name: NewExercise.name,
                  route: NewExercise.routeName,
                  icon: Icons.directions_run_rounded,
                ),
                CustomTile(
                  context: context,
                  name: MVCTesting.name,
                  route: MVCTesting.routeName,
                  icon: Icons.airline_seat_legroom_extra,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Connect Device'),
        icon: const Icon(Icons.bluetooth_rounded),
        onPressed: () async {
          await showDialog<void>(
            context: context,
            useSafeArea: true,
            barrierDismissible: false,
            builder: (_) {
              return AlertDialog(
                scrollable: true,
                content: const DeviceScanner(),
                title: const Text('Select Bluetooth Device', textAlign: TextAlign.center),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              );
            },
          );
        },
      ),
    );
  }

  void aboutDialog() {
    showAboutDialog(
      context: context,
      applicationVersion: '1.0.0',
      applicationName: HomePage.name,
      applicationLegalese: 'Application Legalese',
      applicationIcon: const Icon(Icons.account_circle_rounded),
      children: <Text>[const Text('Mitul Vaghamshi'), const Text('mitulvaghmashi@gmail.com')],
    );
  }
}
