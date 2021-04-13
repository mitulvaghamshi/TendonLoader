import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:tendon_loader/utils/app/constants.dart';
import 'package:tendon_loader/utils/controller/data_adapter.dart';
import 'package:tendon_loader/utils/modal/exercise_data.dart';

class DataStorage {
  static Future<void> upload() async {
    // if (!DataAdapter.hasData) return;
    final Box<Object> _exerciseBox = await Hive.openBox<Object>(Keys.keyExerciseBox);
    final ExerciseData _data = ExerciseData.fromMap(_exerciseBox.toMap());
    _data.collection = DataAdapter.average();
    final DateTime _dtNow = DateTime.now();
    final String _date = DateFormat('y-MM-dd').format(_dtNow).replaceAll('-', '_');
    final String _time = DateFormat('hh:mm a').format(_dtNow).replaceAll(RegExp(r'[\s:]'), '_');
    const String _type = 'EXERCISE_';
    final String _userId = (await Hive.openBox<Object>(Keys.keyLoginBox)).get(Keys.keyUsername) as String;

    final CollectionReference allUsers = FirebaseFirestore.instance.collection('all-users');
    final DocumentReference currentUser = allUsers.doc(_userId);
    final CollectionReference allExports = currentUser.collection('all-exports');
    final DocumentReference day = allExports.doc(_date);
    await day.set(<String, dynamic>{_type + _time: _data.toMap()});
    DataAdapter.clear();
  }
}
// final DocumentReference doc = user.reference.collection('all_exports').doc('2021_04_10');
