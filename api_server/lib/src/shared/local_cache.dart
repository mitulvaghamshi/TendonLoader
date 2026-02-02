import 'package:api_server/api_server.dart';

class LocalCache {
  factory LocalCache() => instance;

  const LocalCache._()
    : users = const {},
      settings = const {},
      exercises = const {},
      prescriptions = const {};

  static const instance = LocalCache._();

  /// Cache key: [User.id]
  final Map<int, User> users;

  /// Cache key: [Settings.id]
  final Map<int, Settings> settings;

  /// Cache key: [Exercise.userId][Exercise.id]
  final Map<int, Map<int, Exercise>> exercises;

  /// Cache key: [Prescription.id]
  final Map<int, Prescription> prescriptions;

  void clear() {
    users.clear();
    settings.clear();
    exercises.clear();
    prescriptions.clear();
  }
}
