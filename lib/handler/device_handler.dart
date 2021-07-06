import 'dart:async';
import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/constants/progressor.dart';
import 'package:tendon_loader/handler/graph_data_handler.dart';
import 'package:tendon_loader/modal/chartdata.dart';
import 'package:tendon_loader/utils/extension.dart';

double lastMinTime = 0;
bool isDeviceRunning = false;
final List<ChartData> exportDataList = <ChartData>[];

Completer<bool>? propCompleter;
BluetoothDevice? progressor;
BluetoothCharacteristic? dataChar;
BluetoothCharacteristic? controlChar;

String get deviceName => progressor!.name.isEmpty ? progressor!.id.id : progressor!.name;

Future<void> openBluetoothSetting() async => AppSettings.openBluetoothSettings();

Future<void> setNotification(bool value) async => dataChar!.setNotifyValue(value);

Future<void> sleepDevice() async => controlChar!.write(<int>[cmdEnterSleep]);

Future<void> stopDeviceScan() async => FlutterBlue.instance.stopScan();

Future<void> startDeviceScan() async {
  await FlutterBlue.instance.startScan(
    timeout: const Duration(seconds: 2),
    withDevices: <Guid>[Guid(uuidService)],
    withServices: <Guid>[Guid(uuidService)],
  );
}

Future<void> startTaring() async {
  if (!isDeviceRunning) {
    isDeviceRunning = true;
    await controlChar!.write(<int>[cmdStartWeightMeasurement]);
  }
}

Future<void> stopTaring() async {
  if (isDeviceRunning) {
    await controlChar!.write(<int>[cmdTareScale]).then((_) {
      isDeviceRunning = false;
      lastMinTime = 0;
      clearGraphData();
      exportDataList.clear();
    });
  }
}

Future<void> startWeightMeasuring() async {
  if (!isDeviceRunning) {
    lastMinTime = 0;
    clearGraphData();
    exportDataList.clear();
    if (simulateBT) {
      _fakeListen();
    } else {
      await controlChar!.write(<int>[cmdStartWeightMeasurement]);
    }
    isDeviceRunning = true;
  }
}

Future<void> stopWeightMeasuring() async {
  if (isDeviceRunning) {
    if (simulateBT) {
      _timer?.cancel();
    } else {
      await controlChar!.write(<int>[cmdStopWeightMeasuremnt]);
    }
    isDeviceRunning = false;
    lastMinTime = 0;
    clearGraphData();
  }
}

Future<void> disconnectDevice() async {
  if (progressor != null) {
    await progressor!.disconnect();
    progressor = dataChar = controlChar = null;
    isDeviceRunning = false;
    lastMinTime = 0;
    clearGraphData();
    propCompleter = null;
    exportDataList.clear();
  }
}

Future<void> connectDevice(BluetoothDevice device) async => device.connect();

Future<bool> getProps(BluetoothDevice device) async {
  if (progressor != null && dataChar != null && controlChar != null) {
    return Future<void>.delayed(const Duration(milliseconds: 800), startTaring).then((_) => true);
  } else if (propCompleter == null) {
    propCompleter = Completer<bool>();
    for (final BluetoothService s in await device.discoverServices()) {
      for (final BluetoothCharacteristic c in s.characteristics) {
        if (c.uuid == Guid(uuidControl)) {
          controlChar = c;
        } else if (c.uuid == Guid(uuidData)) {
          dataChar = c;
        }
      }
    }
    await setNotification(true);
    if (Platform.isAndroid) await device.requestMtu(120);
    if (dataChar != null && controlChar != null) {
      addListener();
      progressor = device;
      await Future<void>.delayed(const Duration(milliseconds: 800), startTaring).then((_) {
        propCompleter!.complete(true);
      });
    }
  }
  return propCompleter!.future;
}

void addListener() {
  dataChar!.value.listen((List<int> data) {
    if (isDeviceRunning && data.isNotEmpty && data[0] == resWeightMeasurement) {
      for (int x = 2; x < data.length; x += 8) {
        final double weight = data.getRange(x, x + 4).toList().toWeight;
        final double time = data.getRange(x + 4, x + 8).toList().toTime;
        if (time > lastMinTime) {
          lastMinTime = time;
          final ChartData element = ChartData(load: weight, time: time);
          exportDataList.add(element);
          graphDataSink.add(element);
        }
      }
    }
  });
}

// simulator start
late Timer? _timer;
late bool simulateBT;

void _fakeListen() {
  double fakeLoad = 0;
  _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
    final ChartData element = ChartData(load: fakeLoad += 2, time: timer.tick.toDouble());
    exportDataList.add(element);
    graphDataSink.add(element);
    if (fakeLoad++ > 10) fakeLoad = 0;
  });
}
// simulator end
