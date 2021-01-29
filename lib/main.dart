import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'bluetooth/bluetooth_off.dart';
import 'homepage.dart';
import 'screens/exercise_mode.dart';
import 'screens/live_data.dart';
import 'screens/mvic_testing.dart';

void main() => runApp(TendonLoaderApp());

class TendonLoaderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tendon Loader',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StreamBuilder<BluetoothState>(
        stream: FlutterBlue.instance.state,
        initialData: BluetoothState.unknown,
        builder: (_, snapshot) {
          return snapshot.data == BluetoothState.on
              ? HomePage(title: 'Tendon Loader')
              : BluetoothOff(state: snapshot.data);
        },
      ),
      routes: {
        'Live Data': (_) => LiveData(title: 'Live Data'),
        'Exercise Mode': (_) => ExerciseMode(title: 'Exercise Mode'),
        'MVIC Testing': (_) => MVICTesting(title: 'MVIC Testing'),
        'BluetoothOff': (_) => BluetoothOff(),
      },
    );
  }
}
