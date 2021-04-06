import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/components/custom_button.dart';
import 'package:tendon_loader/components/custom_image.dart';
import 'package:tendon_loader/utils/bluetooth.dart';
import 'package:tendon_loader/utils/constants.dart' show Images, Descriptions;
import 'package:tendon_loader/utils/location.dart';

class DeviceScanner extends StatelessWidget {
  const DeviceScanner({Key/*?*/ key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const ConnectedDeviceTile();
}

class ConnectedDeviceTile extends StatelessWidget {
  const ConnectedDeviceTile({Key/*?*/ key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<BluetoothDevice>>(
      initialData: const <BluetoothDevice>[],
      stream: Stream<List<BluetoothDevice>>.fromFuture(FlutterBlue.instance.connectedDevices),
      builder: (_, AsyncSnapshot<List<BluetoothDevice>> snapshot) {
        return snapshot.data.isNotEmpty ? DeviceList(devices: snapshot.data) : const BluetoothTile();
      },
    );
  }
}

class BluetoothTile extends StatelessWidget {
  const BluetoothTile({Key/*?*/ key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BluetoothState>(
      initialData: BluetoothState.unknown,
      stream: FlutterBlue.instance.state,
      builder: (_, AsyncSnapshot<BluetoothState> snapshot) {
        return snapshot.data == BluetoothState.off ? const EnableBluetoothTile() : const LocationTile();
      },
    );
  }
}

class LocationTile extends StatelessWidget {
  const LocationTile({Key/*?*/ key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      initialData: false,
      stream: Locator.stream,
      builder: (_, AsyncSnapshot<bool> snapshot) => snapshot.data/*!*/ ? const ScanResultTile() : const EnableLocationTile(),
    );
  }
}

class ScanResultTile extends StatelessWidget {
  const ScanResultTile({Key/*?*/ key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ScanResult>>(
      initialData: const <ScanResult>[],
      stream: FlutterBlue.instance.scanResults,
      builder: (_, AsyncSnapshot<List<ScanResult>> snapshot) => snapshot.data.isEmpty ? const ScannerTile() : DeviceList(results: snapshot.data),
    );
  }
}

class ScannerTile extends StatelessWidget {
  const ScannerTile({Key/*?*/ key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      initialData: false,
      stream: FlutterBlue.instance.isScanning,
      builder: (_, AsyncSnapshot<bool> snapshot) => snapshot.data/*!*/ ? const StopScanTile() : const StartScanTile(),
    );
  }
}

class DeviceList extends StatelessWidget {
  const DeviceList({Key key, this.results = const <ScanResult>[], this.devices = const <BluetoothDevice>[]}) : super(key: key);

  final List<ScanResult> results;
  final List<BluetoothDevice> devices;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Text(Descriptions.descClickToConnect, textAlign: TextAlign.center),
        const SizedBox(height: 20),
        ...results?.map((ScanResult result) => DeviceTile(device: result.device)),
        ...devices?.map((BluetoothDevice device) => DeviceTile(device: device)),
        const SizedBox(height: 20),
        CustomButton(text: 'Close', icon: Icons.cancel, onPressed: () => Navigator.pop<void>(context)),
      ],
    );
  }
}

class DeviceTile extends StatelessWidget {
  const DeviceTile({Key key, this.device}) : super(key: key);

  final BluetoothDevice device;

  String get _deviceName => device.name.isEmpty ? device.id.toString() : device.name;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BluetoothDeviceState>(
      stream: device.state,
      builder: (_, AsyncSnapshot<BluetoothDeviceState> snapshot) {
        if (snapshot.data == BluetoothDeviceState.connected) {
          return ListTile(
            horizontalTitleGap: 0,
            title: Text(_deviceName),
            subtitle: const Text('Click to disconnect'),
            onTap: Bluetooth.disconnect,
            contentPadding: const EdgeInsets.all(5),
            leading: const Icon(Icons.bluetooth_connected_rounded, size: 40),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            trailing: const CircleAvatar(radius: 20, backgroundColor: Colors.green),
          );
        } else {
          return ListTile(
            horizontalTitleGap: 0,
            title: Text(_deviceName),
            subtitle: const Text('Click to connect'),
            onTap: () => Bluetooth.connect(device),
            contentPadding: const EdgeInsets.all(5),
            leading: const Icon(Icons.bluetooth_rounded, size: 40),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            trailing: const CircleAvatar(radius: 20, backgroundColor: Colors.deepOrange),
          );
        }
      },
    );
  }
}

class StopScanTile extends StatelessWidget {
  const StopScanTile({Key/*?*/ key}) : super(key: key);

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
        const CustomButton(text: 'Stop', icon: Icons.close_rounded, onPressed: Bluetooth.stopScan),
      ],
    );
  }
}

class StartScanTile extends StatelessWidget {
  const StartScanTile({Key/*?*/ key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: const <Widget>[
        CustomImage(name: Images.imgEnableDevice),
        Text(Descriptions.descEnableDevice, textAlign: TextAlign.center),
        SizedBox(height: 30),
        CustomButton(text: 'Scan', icon: Icons.search_rounded, onPressed: Bluetooth.startScan),
      ],
    );
  }
}

class EnableLocationTile extends StatelessWidget {
  const EnableLocationTile({Key/*?*/ key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: const <Widget>[
        CustomImage(name: Images.imgEnableLocation),
        Text(Descriptions.descLocation1, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 20),
        Text(Descriptions.descLocation2, textAlign: TextAlign.center, style: TextStyle(fontSize: 14)),
        SizedBox(height: 15),
        Text(Descriptions.descLocation3, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic)),
        SizedBox(height: 30),
        CustomButton(text: 'Enable', icon: Icons.location_on_rounded, onPressed: Locator.requestService),
      ],
    );
  }
}

class EnableBluetoothTile extends StatelessWidget {
  const EnableBluetoothTile({Key/*?*/ key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: const <Widget>[
        CustomImage(name: Images.imgEnableBluetooth),
        Text(Descriptions.descEnableBluetooth, textAlign: TextAlign.center),
        SizedBox(height: 30),
        CustomButton(text: 'Enable', icon: Icons.bluetooth_rounded, onPressed: Bluetooth.enable),
      ],
    );
  }
}
