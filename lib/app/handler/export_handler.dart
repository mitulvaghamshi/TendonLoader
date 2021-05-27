import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:hive/hive.dart';
import 'package:tendon_loader/shared/constants.dart';
import 'package:tendon_loader/shared/modal/chartdata.dart';
import 'package:tendon_loader/shared/modal/data_model.dart';

mixin ExportHandler {
  static Future<bool> _isConnected() async => (await Connectivity().checkConnectivity()) != ConnectivityResult.none;

  static Future<bool> export(DataModel model, bool later) async {
    final Map<String, String?> _metaData = model.sessionInfo!.toMap();
    if (model.prescription != null) _metaData.addAll(model.prescription!.toMap());
    return (!later && await _isConnected() ? _upload : _save)(<String, dynamic>{
      Keys.KEY_META_DATA: _metaData,
      Keys.KEY_USER_DATA: model.dataList!.map((ChartData data) {
        return <String, double?>{Keys.KEY_CHART_Y: data.time, Keys.KEY_CHART_X: data.load};
      }).toList(),
    });
  }

  static Future<int> checkLocalData() async {
    return await _isConnected() ? Hive.box<Map<dynamic, dynamic>>(Keys.KEY_USER_EXPORTS_BOX).length : 0;
  }

  static Future<bool> reExport() async {
    late bool result;
    if (await _isConnected()) {
      final Box<Map<dynamic, dynamic>> _userExportsBox = Hive.box(Keys.KEY_USER_EXPORTS_BOX);
      for (final dynamic key in _userExportsBox.keys) {
        result = await _upload(_userExportsBox.get(key)!);
        if (result) await _userExportsBox.delete(key);
      }
    }
    return result;
  }

  static Future<bool> _save(Map<String, dynamic> exportInfo) async {
    await Hive.box<Map<dynamic, dynamic>>(Keys.KEY_USER_EXPORTS_BOX).put(exportInfo.hashCode, exportInfo);
    return true;
  }

  static Future<bool> _upload(Map<dynamic, dynamic> exportInfo) async {
    final Map<String, String> _metaData =
        Map<String, String>.from(exportInfo[Keys.KEY_META_DATA] as Map<dynamic, dynamic>);
    await FirebaseFirestore.instance
        .collection(Keys.KEY_ALL_USERS)
        .doc(_metaData[Keys.KEY_USERNAME])
        .collection(Keys.KEY_ALL_EXPORTS)
        .doc(_metaData[Keys.KEY_EXPORT_DATE])
        .set(<String, dynamic>{_metaData[Keys.KEY_EXPORT_TIME]!: exportInfo}, SetOptions(merge: true));
    return true;
  }
}
