import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:tendon_loader/utils/app/constants.dart' show Keys;
import 'package:tendon_loader/utils/controller/bluetooth.dart';
import 'package:tendon_loader/utils/modal/chart_data.dart';
import 'package:tendon_loader/utils/modal/exercise_data.dart';

class DataStorage {
  static Future<bool> _isConnected() async {
    return (await Connectivity().checkConnectivity()) != ConnectivityResult.none;
  }

  static Future<void> export({List<ChartData> dataList, DateTime dateTime, String exportType = 'UNKNOWN_', ExerciseData exerciseData}) async {
    print('export start');
    final Map<String, String> _mataData = <String, String>{};
    _mataData[Keys.keyUsername] = (await Hive.openBox<Object>(Keys.keyLoginBox)).get(Keys.keyUsername) as String;
    _mataData['exportType'] = exportType;
    _mataData['isComplete'] = true.toString();
    _mataData['progressotId'] = Bluetooth.deviceName;
    if (exerciseData != null) _mataData.addAll(exerciseData.toMap());
    _mataData['exportDate'] = DateFormat('y-MM-dd').format(dateTime);
    _mataData['exportTime'] = DateFormat('hh:mm:ss a').format(dateTime);

    final Map<String, dynamic> _exportInfo = <String, dynamic>{
      'metaData': _mataData,
      'userData': dataList.map((ChartData element) => <String, double>{'time': element.time, 'load': element.load}).toList(),
    };

    if (await _isConnected()) {
      print('connected');
      await _upload(_exportInfo);
    } else {
      print('not connected');
      await _save(_exportInfo);
    }
  }

  static Future<void> reExport() async {
    print('re export');
    final Box<Map<String, dynamic>> userExports = await Hive.openBox<Map<String, dynamic>>('user_exports');
    for (final dynamic key in userExports.keys) {
      await _upload(userExports.get(key)).then((_) async {
        await userExports.delete(key);
      });
    }
  }

  static Future<void> _save(Map<String, dynamic> exportInfo) async {
    print('local saving');
    final Box<Map<String, dynamic>> userExports = await Hive.openBox<Map<String, dynamic>>('user_exports');
    await userExports.add(exportInfo);
  }

  static Future<void> _upload(Map<String, dynamic> exportInfo) async {
    print('cloud saving');
    final Map<String, String> metaData = exportInfo['metaData'] as Map<String, String>;
    final DocumentReference day = FirebaseFirestore.instance
        .collection(Keys.keyAllUsers)
        .doc(metaData[Keys.keyUsername])
        .collection(Keys.keyAllExports)
        .doc(metaData['exportDate']);
    await day.set(<String, dynamic>{metaData['exportTime']: exportInfo}, SetOptions(merge: true));
  }
}
