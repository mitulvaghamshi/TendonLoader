import 'package:tendon_loader/models/exercise.dart';
import 'package:tendon_loader/models/prescription.dart';
import 'package:tendon_loader/models/settings.dart';
import 'package:tendon_loader/models/user.dart';

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
