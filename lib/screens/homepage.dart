import 'package:flutter/material.dart';
import 'package:tendon_loader/components/custom_tile.dart';
import 'package:tendon_loader/components/logo.dart';
import 'package:tendon_loader/screens/device_scanner.dart';
import 'package:tendon_loader/screens/exercise_mode/new_exercise.dart';
import 'package:tendon_loader/screens/live_data/live_data.dart';
import 'package:tendon_loader/screens/mvc_testing/mvc_testing.dart';
import 'package:tendon_loader/utils/bluetooth.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/';
  static const name = 'Tendon Loader';

  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void dispose() {
    Bluetooth.instance.sleep();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(HomePage.name),
        actions: [IconButton(icon: Icon(Icons.info_outline_rounded), onPressed: () => aboutDialog(context))],
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
                const Logo(image: 'ic_launcher-playstore.webp', scale: 0.7),
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
          await showDialog(
            context: context,
            useSafeArea: true,
            barrierDismissible: false,
            builder: (_) {
              return AlertDialog(
                scrollable: true,
                content: DeviceScanner(),
                title: const Text('Select Bluetooth Device', textAlign: TextAlign.center),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              );
            },
          );
        },
      ),
    );
  }

  void aboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationIcon: Icon(Icons.account_circle_rounded),
      applicationLegalese: 'Application Legalese',
      applicationName: HomePage.name,
      applicationVersion: '1.0.0',
      children: [
        Text('Mitul Vaghamshi'),
        Text('mitulvaghmashi@gmail.com'),
      ],
    );
  }
}
