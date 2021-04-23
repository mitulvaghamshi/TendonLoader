import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:hive/hive.dart';
import 'package:tendon_loader/shared/constants.dart';
import 'package:tendon_loader/shared/modal/chartdata.dart';
import 'package:tendon_loader/shared/modal/prescription.dart';
import 'package:tendon_loader/shared/modal/session_info.dart';

class ExportHandler {
  static Future<bool> _isConnected() async => (await Connectivity().checkConnectivity()) != ConnectivityResult.none;

  static Future<void> export(List<ChartData> dataList, {SessionInfo sessionInfo, Prescription prescription}) async {
    final Map<String, String> metaData = sessionInfo.toMap();
    if(prescription != null) metaData.addAll(prescription.toMap());
    await (await _isConnected() ? _upload : _save)(<String, dynamic>{
      Keys.KEY_META_DATA: metaData,
      Keys.KEY_USER_DATA: dataList.map((ChartData data) => <String, double>{Keys.KEY_CHART_Y: data.time, Keys.KEY_CHART_X: data.load}).toList(),
    });
  }

  static Future<void> reExport() async {
    final Box<Map<String, dynamic>> _userExportsBox = await Hive.openBox<Map<String, dynamic>>(Keys.KEY_USER_EXPORTS_BOX);
    for (final dynamic key in _userExportsBox.keys) {
      await _upload(_userExportsBox.get(key));
      await _userExportsBox.delete(key);
    }
  }

  static Future<void> _save(Map<String, dynamic> exportInfo) async {
    await (await Hive.openBox<Map<String, dynamic>>(Keys.KEY_USER_EXPORTS_BOX)).add(exportInfo);
  }

  static Future<void> _upload(Map<String, dynamic> exportInfo) async {
    final Map<String, String> _metaData = exportInfo[Keys.KEY_META_DATA] as Map<String, String>;
    await FirebaseFirestore.instance
        .collection(Keys.KEY_ALL_USERS)
        .doc(_metaData[Keys.KEY_USERNAME])
        .collection(Keys.KEY_ALL_EXPORTS)
        .doc(_metaData[Keys.KEY_EXPORT_DATE])
        .set(<String, dynamic>{_metaData[Keys.KEY_EXPORT_TIME]: exportInfo}, SetOptions(merge: true));
  }
}
