import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:hive/hive.dart';
import 'package:tendon_loader_lib/constants/constants.dart';
import 'package:tendon_loader_lib/tendon_loader_lib.dart';

Future<bool> _isConnected() async => (await Connectivity().checkConnectivity()) != ConnectivityResult.none;

Future<int> checkLocalData() async {
  return await _isConnected() ? Hive.box<Map<dynamic, dynamic>>(keyExportBox).length : 0;
}

Future<bool> export(DataModel model, bool later) async {
  final Map<String, double> _exportData = <String, double>{};

  for (final ChartData data in model.dataList!) {
    _exportData[data.time!.toString()] = data.load!;
  }

  final Map<String, dynamic> _export = <String, dynamic>{
    'exportData': _exportData,
    'isComplate': model.sessionInfo!.isComplate,
  };

  if (model.sessionInfo!.isMVC) {
    _export['mvcValue'] = model.mvcValue;
  } else {
    _export['prescription'] = model.prescription!.toMap();
  }

  if (!later && await _isConnected()) {
    return _upload(
      _export,
      model.sessionInfo!.userId,
      model.sessionInfo!.progressorId,
      '${model.sessionInfo!.isMVC ? 'M' : 'E'}${model.sessionInfo!.dateTime.millisecondsSinceEpoch}',
    );
  } else {
    return _save(_export, model.sessionInfo!);
  }
}

Future<bool> _save(Map<String, dynamic> export, SessionInfo info) async {
  final Map<String, dynamic> _data = <String, dynamic>{
    'export': export,
    'userId': info.userId,
    'prefix': info.isMVC ? 'M' : 'E',
    'progressorId': info.progressorId,
    'timeStamp': info.dateTime.millisecondsSinceEpoch,
  };
  await Hive.box<Map<dynamic, dynamic>>(keyExportBox).put(export.hashCode, _data);
  return true;
}

Future<bool?> reExport() async {
  late bool? result;
  if (await _isConnected()) {
    final Box<Map<dynamic, dynamic>> _exportsBox = Hive.box(keyExportBox);
    for (final dynamic key in _exportsBox.keys) {
      final Map<String, dynamic> _data = Map<String, dynamic>.from(_exportsBox.get(key)!);
      result = await _submit(_data);
      if (result) await _exportsBox.delete(key);
    }
  }
  return result;
}

Future<bool> _submit(Map<dynamic, dynamic> data) async {
  final Map<String, dynamic> export = Map<String, dynamic>.from(data['export'] as Map<dynamic, dynamic>);
  final String userId = data['userId'] as String;
  final String progressorId = data['progressorId'] as String;
  final String prefixedName = '${data['prefix']}${data['timeStamp']}';
  return _upload(export, userId, progressorId, prefixedName);
}

Future<bool> _upload(Map<String, dynamic> export, String userId, String progresorId, String prefixedName) async {
  await FirebaseFirestore.instance.doc('/$keyDatabaseRoot/$userId/$keyExports/$prefixedName').set(export);
  await FirebaseFirestore.instance
      .doc('/$keyDatabaseRoot/$userId')
      .update(<String, String>{'progressorId': progresorId});
  return true;
}
