import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:hive/hive.dart';
import 'package:tendon_loader_lib/constants/constants.dart';
import 'package:tendon_loader_lib/tendon_loader_lib.dart';
import 'package:tendon_loader_web/app_state/export.dart';

Future<bool> _isConnected() async => (await Connectivity().checkConnectivity()) != ConnectivityResult.none;

Future<int> checkLocalData() async {
  return await _isConnected() ? Hive.box<Map<dynamic, dynamic>>(keyExportBox).length : 0;
}

Future<bool> submit(Export export, bool later) async {
  final Map<String, double> _exportData = <String, double>{};
  for (final ChartData data in export.exportData) {
    _exportData[data.time!.toString()] = data.load!;
  }
  final Map<String, dynamic> _data = <String, dynamic>{
    keyUserId: export.userId,
    keyExportData: _exportData,
    keyIsComplate: export.isComplate,
    keyProgressorId: export.progressorId,
  };
  if (export.isMVC) {
    _data[keyMvcValue] = export.mvcValue;
  } else {
    _data[keyPrescription] = export.prescription!.toMap();
  }
  late bool result;
  if (!later && await _isConnected()) {
    _data[keyTimeStamp] = export.timestamp;
    result = await _upload(_data, export.userId!);
  } else {
    _data[keyTimeStamp] = export.timestamp.millisecondsSinceEpoch;
    result = await _save(_data);
  }
  return Future<bool>.value(result);
}

Future<bool?> reSubmit() async {
  late bool? result;
  if (await _isConnected()) {
    final Box<Map<dynamic, dynamic>> _exportsBox = Hive.box(keyExportBox);
    for (final dynamic key in _exportsBox.keys) {
      final Map<String, dynamic> _data = Map<String, dynamic>.from(_exportsBox.get(key)!);
      final String userId = _data[keyUserId] as String;
      _data[keyTimeStamp] = Timestamp.fromMillisecondsSinceEpoch(_data[keyTimeStamp] as int);
      result = await _upload(_data, userId);
      if (result) await _exportsBox.delete(key);
    }
  }
  return Future<bool>.value(result);
}

Future<bool> _save(Map<String, dynamic> data) async {
  await Hive.box<Map<dynamic, dynamic>>(keyExportBox).put(data.hashCode, data);
  return Future<bool>.value(true);
}

Future<bool> _upload(Map<String, dynamic> data, String userId) async {
  await FirebaseFirestore.instance.collection('/$keyBase/$userId/$keyExports').doc().set(data);
  return Future<bool>.value(true);
}
