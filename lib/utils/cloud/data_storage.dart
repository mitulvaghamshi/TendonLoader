import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:tendon_loader/utils/app/constants.dart' show Keys;
import 'package:tendon_loader/utils/controller/bluetooth.dart';
import 'package:tendon_loader/utils/modal/chart_data.dart';
import 'package:tendon_loader/utils/modal/prescription.dart';

class DataStorage {
  static Future<bool> _isConnected() async {
    return (await Connectivity().checkConnectivity()) != ConnectivityResult.none;
  }

  static Future<void> export(List<ChartData> dataList, DateTime dateTime, String exportType, bool isComplete, {Prescription prescription}) async {
    final Map<String, String> _mataData = <String, String>{};
    _mataData[Keys.KEY_EXPORT_TYPE] = exportType;
    _mataData[Keys.KEY_PROGRESSOR_ID] = Bluetooth.deviceName;
    _mataData[Keys.KEY_DATA_STATUS] = isComplete ? 'Complete' : 'Incomplete';
    _mataData[Keys.KEY_EXPORT_DATE] = DateFormat(Keys.KEY_DATE_FORMAT).format(dateTime);
    _mataData[Keys.KEY_EXPORT_TIME] = DateFormat(Keys.KEY_TIME_FORMAT).format(dateTime);
    _mataData[Keys.KEY_USERNAME] = (await Hive.openBox<Object>(Keys.KEY_LOGIN_BOX)).get(Keys.KEY_USERNAME) as String;
    if (prescription != null) _mataData.addAll(prescription.toMap());

    final Map<String, dynamic> _exportInfo = <String, dynamic>{
      Keys.KEY_META_DATA: _mataData,
      Keys.KEY_USER_DATA: dataList.map((ChartData data) {
        return <String, double>{Keys.KEY_CHART_Y: data.time, Keys.KEY_CHART_X: data.load};
      }).toList(),
    };

    await _isConnected() ? await _upload(_exportInfo) : await _save(_exportInfo);
  }

  static Future<void> reExport() async {
    final Box<Map<String, dynamic>> _userExportsBox = await Hive.openBox<Map<String, dynamic>>(Keys.KEY_USER_EXPORTS_BOX);
    for (final dynamic key in _userExportsBox.keys) {
      await _upload(_userExportsBox.get(key));
      await _userExportsBox.delete(key);
    }
  }

  static Future<void> _save(Map<String, dynamic> exportInfo) async {
    final Box<Map<String, dynamic>> _userExportsBox = await Hive.openBox<Map<String, dynamic>>(Keys.KEY_USER_EXPORTS_BOX);
    await _userExportsBox.add(exportInfo);
  }

  static Future<void> _upload(Map<String, dynamic> exportInfo) async {
    final Map<String, String> _metaData = exportInfo[Keys.KEY_META_DATA] as Map<String, String>;
    final DocumentReference _user = FirebaseFirestore.instance.collection(Keys.KEY_ALL_USERS).doc(_metaData[Keys.KEY_USERNAME]);
    await _user.set(<String, dynamic>{Keys.KEY_LAST_ACTIVE: _metaData[Keys.KEY_EXPORT_TIME] + ' ' + _metaData[Keys.KEY_EXPORT_TIME]});
    final DocumentReference _doc = _user.collection(Keys.KEY_ALL_EXPORTS).doc(_metaData[Keys.KEY_EXPORT_DATE]);
    await _doc.set(<String, dynamic>{_metaData[Keys.KEY_EXPORT_TIME]: exportInfo}, SetOptions(merge: true));
  }
}
