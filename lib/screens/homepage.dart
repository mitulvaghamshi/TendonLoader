
import 'package:flutter/material.dart';
import 'package:tendon_loader/components/app_logo.dart';
import 'package:tendon_loader/components/bluetooth.dart';
import 'package:tendon_loader/screens/device_scanner.dart';
import 'package:tendon_loader/screens/exercise_mode.dart';
import 'package:tendon_loader/screens/live_data.dart';
import 'package:tendon_loader/screens/mvic_testing.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/';
  static const name = 'Tendon Loader';

  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void dispose() {
    Bluetooth.instance.sleep;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(HomePage.name), centerTitle: true),
      body: SingleChildScrollView(
        child: Card(
          elevation: 16.0,
          margin: const EdgeInsets.all(16.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Logo(),
                const SizedBox(height: 10.0),
                _buildListTile(context, LiveData.name, LiveData.routeName, Icons.show_chart_rounded),
                const SizedBox(height: 10.0),
                _buildListTile(context, ExerciseMode.name, ExerciseMode.routeName, Icons.directions_run_rounded),
                const SizedBox(height: 10.0),
                _buildListTile(context, MVICTesting.name, MVICTesting.routeName, Icons.airline_seat_legroom_extra),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Connect Device'),
        icon: Icon(Icons.bluetooth_rounded),
        onPressed: () => _findDevice(context),
      ),
    );
  }

  ListTile _buildListTile(BuildContext context, String name, String route, IconData icon) {
    return ListTile(
      dense: true,
      leading: Icon(icon, size: 30.0),
      contentPadding: const EdgeInsets.all(16.0),
      trailing: Icon(Icons.keyboard_arrow_right_rounded),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      onTap: () {
        if (Bluetooth.device != null) {
          Navigator.of(context).pushNamed(route);
        } else {
          _findDevice(context);
        }
      },
      title: Text(name, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
    );
  }

  void _findDevice(BuildContext context) async {
    await showDialog(
      context: context,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          content: DeviceScanner(),
          title: Text('Select Bluetooth Device', textAlign: TextAlign.center),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        );
      },
    );
  }
}
