import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore, SetOptions;
import 'package:connectivity/connectivity.dart' show Connectivity, ConnectivityResult;
import 'package:hive/hive.dart' show Box, Hive;
import 'package:tendon_support_lib/tendon_support_lib.dart' show Keys;
import 'package:tendon_support_module/modal/chartdata.dart';
import 'package:tendon_support_module/modal/data_model.dart';

Future<bool> _isConnected() async => (await Connectivity().checkConnectivity()) != ConnectivityResult.none;

Future<bool> export(DataModel model, bool later) async {
  final Map<String, String?> _metaData = model.sessionInfo!.toMap();
  if (model.prescription != null) _metaData.addAll(model.prescription!.toMap());
  return (!later && await _isConnected() ? _upload : _save)(<String, dynamic>{
    Keys.keyMetaData: _metaData,
    Keys.keyUserData: model.dataList!.map((ChartData data) {
      return <String, double?>{Keys.keyChartX: data.time, Keys.keyChartY: data.load};
    }).toList(),
  });
}

Future<int> checkLocalData() async {
  return await _isConnected() ? Hive.box<Map<dynamic, dynamic>>(Keys.keyUserExportsBox).length : 0;
}

Future<bool> reExport() async {
  late bool result;
  if (await _isConnected()) {
    final Box<Map<dynamic, dynamic>> _userExportsBox = Hive.box(Keys.keyUserExportsBox);
    for (final dynamic key in _userExportsBox.keys) {
      result = await _upload(_userExportsBox.get(key)!);
      if (result) await _userExportsBox.delete(key);
    }
  }
  return result;
}

Future<bool> _save(Map<String, dynamic> exportInfo) async {
  await Hive.box<Map<dynamic, dynamic>>(Keys.keyUserExportsBox).put(exportInfo.hashCode, exportInfo);
  return true;
}

Future<bool> _upload(Map<dynamic, dynamic> exportInfo) async {
  final Map<String, String> _metaData = Map<String, String>.from(exportInfo[Keys.keyMetaData] as Map<dynamic, dynamic>);
  await FirebaseFirestore.instance
      .collection(Keys.keyAllUsers)
      .doc(_metaData[Keys.keyUsername])
      .collection(Keys.keyAllExports)
      .doc(_metaData[Keys.keyExportDate])
      .set(<String, dynamic>{_metaData[Keys.keyExportTime]!: exportInfo}, SetOptions(merge: true));
  return true;
}