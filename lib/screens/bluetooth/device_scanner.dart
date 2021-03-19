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
    return ConnectedDeviceTile();
  }
}

class ConnectedDeviceTile extends StatelessWidget {
  const ConnectedDeviceTile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<BluetoothDevice>>(
      initialData: [],
      stream: Stream.fromFuture(FlutterBlue.instance.connectedDevices),
      builder: (_, snapshot) => snapshot.data.isNotEmpty ? DisconnectTile() : BluetoothTile(),
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
      builder: (_, snapshot) => snapshot.data == BluetoothState.off ? EnableBluetoothTile() : LocationTile(),
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
      builder: (_, snapshot) => snapshot.data ? ScanResultTile() : EnableLocationTile(),
    );
  }
}

class ScanResultTile extends StatelessWidget {
  const ScanResultTile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ScanResult>>(
      initialData: [],
      stream: FlutterBlue.instance.scanResults,
      builder: (_, snapshot) => snapshot.data.isNotEmpty ? DeviceTile(result: snapshot.data.first) : ScannerTile(),
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
      builder: (_, snapshot) => snapshot.data ? StopScanTile() : StartScanTile(),
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
      builder: (_, snapshot) {
        if (snapshot.data == BluetoothDeviceState.connected) return DisconnectTile();
        return ConnectTile(device: result.device);
      },
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
      children: [
        const Text(
          'Click on the device name to connect\n Note: this might take a moment to connect.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        CustomButton(
          text: device.name,
          icon: Icons.bluetooth_rounded,
          color: Colors.deepOrange[600],
          onPressed: () async => await Bluetooth.instance.connect(device),
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
      children: [
        const Text(
          'Device is connected successfully and ready to use!\nClick on the device name to disconnect.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        CustomButton(
          color: Colors.green[700],
          text: Bluetooth.device.name,
          icon: Icons.bluetooth_connected_rounded,
          onPressed: () async => await Bluetooth.instance.disconnect(),
        ),
        const SizedBox(height: 20),
        CustomButton(
          text: 'Close',
          icon: Icons.cancel,
          color: Colors.black,
          onPressed: () => Navigator.pop(context),
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
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const CircularProgressIndicator(),
            const Text('Please wait...', style: TextStyle(fontSize: 20)),
          ],
        ),
        const SizedBox(height: 30),
        CustomButton(
          text: 'Stop',
          icon: Icons.close_rounded,
          color: Colors.deepOrangeAccent,
          onPressed: () async => Bluetooth.instance.stopScan(),
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
      children: [
        const CustomImage(name: 'enable_device.webp'),
        const Text(
          'Activate your device by pressing the button, then press scan to find the device',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),
        CustomButton(
          text: 'Scan',
          color: Colors.black,
          icon: Icons.search_rounded,
          onPressed: () async => await Bluetooth.instance.startScan(),
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
      children: [
        const CustomImage(name: 'enable_location.webp'),
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
          color: Colors.black,
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
      children: [
        const CustomImage(name: 'enable_bluetooth.webp'),
        const Text(
          'This app needs Bluetooth to communicate with your Progressor. Please enable Bluetooth on your device.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),
        CustomButton(
          text: 'Enable',
          color: Colors.black,
          icon: Icons.bluetooth_rounded,
          onPressed: () async => await Bluetooth.instance.enable(),
        ),
      ],
    );
  }
}
