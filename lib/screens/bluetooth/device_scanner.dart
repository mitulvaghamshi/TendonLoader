import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:location/location.dart';
import 'package:tendon_loader/components/custom_button.dart';
import 'package:tendon_loader/components/custom_image.dart';
import 'package:tendon_loader/utils/bluetooth.dart';
import 'package:tendon_loader/utils/location.dart';

class DeviceScanner extends StatelessWidget {
  const DeviceScanner({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Location.instance.serviceEnabled().then(Locator.sink.add);
    return const ConnectedDeviceTile();
  }
}

class ConnectedDeviceTile extends StatelessWidget {
  const ConnectedDeviceTile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<BluetoothDevice>>(
      initialData: const <BluetoothDevice>[],
      stream: Stream<List<BluetoothDevice>>.fromFuture(FlutterBlue.instance.connectedDevices),
      builder: (_, AsyncSnapshot<List<BluetoothDevice>> snapshot) => snapshot.data.isNotEmpty ? const DisconnectTile() : const BluetoothTile(),
    );
  }
}

class BluetoothTile extends StatelessWidget {
  const BluetoothTile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BluetoothState>(
      initialData: BluetoothState.unknown,
      stream: FlutterBlue.instance.state,
      builder: (_, AsyncSnapshot<BluetoothState> snapshot) =>
          snapshot.data == BluetoothState.off ? const EnableBluetoothTile() : const LocationTile(),
    );
  }
}

class LocationTile extends StatelessWidget {
  const LocationTile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      initialData: false,
      stream: Locator.stream,
      builder: (_, AsyncSnapshot<bool> snapshot) => snapshot.data ? const ScanResultTile() : const EnableLocationTile(),
    );
  }
}

class ScanResultTile extends StatelessWidget {
  const ScanResultTile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ScanResult>>(
      initialData: const <ScanResult>[],
      stream: FlutterBlue.instance.scanResults,
      builder: (_, AsyncSnapshot<List<ScanResult>> snapshot) =>
          snapshot.data.isNotEmpty ? DeviceTile(result: snapshot.data.first) : const ScannerTile(),
    );
  }
}

class ScannerTile extends StatelessWidget {
  const ScannerTile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      initialData: false,
      stream: FlutterBlue.instance.isScanning,
      builder: (_, AsyncSnapshot<bool> snapshot) => snapshot.data ? const StopScanTile() : const StartScanTile(),
    );
  }
}

class DeviceTile extends StatelessWidget {
  const DeviceTile({Key key, @required this.result}) : super(key: key);

  final ScanResult result;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BluetoothDeviceState>(
      stream: result.device.state,
      builder: (_, AsyncSnapshot<BluetoothDeviceState> snapshot) =>
          snapshot.data == BluetoothDeviceState.connected ? const DisconnectTile() : ConnectTile(device: result.device),
    );
  }
}

class ConnectTile extends StatelessWidget {
  const ConnectTile({Key key, @required this.device}) : super(key: key);

  final BluetoothDevice device;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Text('Click on the device name to connect\n Note: this might take a moment to connect.', textAlign: TextAlign.center),
        const SizedBox(height: 20),
        CustomButton(
          text: device.name,
          background: Colors.blue[700],
          icon: Icons.bluetooth_rounded,
          onPressed: () => Bluetooth.instance.connect(device),
        ),
      ],
    );
  }
}

class DisconnectTile extends StatelessWidget {
  const DisconnectTile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Text('Device is connected successfully and ready to use!\nClick on the device name to disconnect.', textAlign: TextAlign.center),
        const SizedBox(height: 20),
        CustomButton(
          text: Bluetooth.device.name,
          background: Colors.green[700],
          icon: Icons.bluetooth_connected_rounded,
          onPressed: Bluetooth.instance.disconnect,
        ),
        const SizedBox(height: 20),
        CustomButton(
          text: 'Close',
          icon: Icons.cancel,
          onPressed: () => Navigator.pop<void>(context),
        ),
      ],
    );
  }
}

class StopScanTile extends StatelessWidget {
  const StopScanTile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const <Widget>[CircularProgressIndicator(), Text('Please wait...', style: TextStyle(fontSize: 20))],
        ),
        const SizedBox(height: 30),
        CustomButton(
          text: 'Stop',
          icon: Icons.close_rounded,
          onPressed: Bluetooth.instance.stopScan,
        ),
      ],
    );
  }
}

class StartScanTile extends StatelessWidget {
  const StartScanTile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const CustomImage(name: 'enable_device.svg'),
        const Text('Activate your device by pressing the button, then press scan to find the device', textAlign: TextAlign.center),
        const SizedBox(height: 30),
        CustomButton(
          text: 'Scan',
          icon: Icons.search_rounded,
          onPressed: Bluetooth.instance.startScan,
        ),
      ],
    );
  }
}

class EnableLocationTile extends StatelessWidget {
  const EnableLocationTile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const CustomImage(name: 'enable_location.png'),
        const Text(
          'This app uses bluetooth to communicate with your Progressor.',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        const Text(
          'Scanning for bluetooth devices can be used to locate you. That\'s why we ask you to permit location services. We\'re only using this permission to scan for your Progressor.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 15),
        const Text(
          'We\'ll never collect your physical location.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
        ),
        const SizedBox(height: 30),
        CustomButton(
          text: 'Enable',
          icon: Icons.location_on_rounded,
          onPressed: () async => Locator.sink.add(await Location.instance.requestService()),
        ),
      ],
    );
  }
}

class EnableBluetoothTile extends StatelessWidget {
  const EnableBluetoothTile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const CustomImage(name: 'enable_bluetooth.svg'),
        const Text(
          'This app needs Bluetooth to communicate with your Progressor. Please enable Bluetooth on your device.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),
        CustomButton(
          text: 'Enable',
          icon: Icons.bluetooth_rounded,
          onPressed: Bluetooth.instance.enable,
        ),
      ],
    );
  }
}
