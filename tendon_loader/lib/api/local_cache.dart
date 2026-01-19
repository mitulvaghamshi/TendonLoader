import 'package:server/models/exercise.dart';
import 'package:server/models/prescription.dart';
import 'package:server/models/settings.dart';
import 'package:server/models/user.dart';

class LocalCache {
  LocalCache._();

  static final LocalCache instance = LocalCache._();

  final Map<int, User> users = {};
  final Map<int, Prescription> prescriptions = {};
  final Map<int, Settings> settings = {};

  /// Cache key is [Exercise.userId]
  final Map<int, Map<int, Exercise>> exercises = {};

  void clear() {
    users.clear();
    prescriptions.clear();
    settings.clear();
    exercises.clear();
  }
}
