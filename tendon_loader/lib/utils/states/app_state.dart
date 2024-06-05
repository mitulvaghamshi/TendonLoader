import 'package:flutter/foundation.dart';
import 'package:tendon_loader/models/prescription.dart';
import 'package:tendon_loader/models/settings.dart';
import 'package:tendon_loader/models/user.dart';
import 'package:tendon_loader/services/exercise_service.dart';
import 'package:tendon_loader/services/prescription_service.dart';
import 'package:tendon_loader/services/settings_service.dart';
import 'package:tendon_loader/services/user_service.dart';

class AppState extends ChangeNotifier {
  AppState({
    required this.userService,
    required this.settingsService,
    required this.exerciseService,
    required this.prescriptionService,
  })  : user = const User.empty(),
        settings = const Settings.empty(),
        prescription = const Prescription.empty();

  User user;
  Settings settings;
  Prescription prescription;
  bool modified = false;

  final UserService userService;
  final SettingsService settingsService;
  final ExerciseService exerciseService;
  final PrescriptionService prescriptionService;

  Future<void> authenticate({
    required final String username,
    required final String password,
  }) async {
    final userSnap = await userService.auth(user: username, pass: password);
    if (userSnap.hasData) user = userSnap.requireData;

    final settingsSnap = await settingsService.getBy(userId: user.id!);
    if (userSnap.hasData) settings = settingsSnap.requireData;

    notifyListeners();
  }

  void get<T>(final T Function(T state) callback) {
    modified = true;
    if (T == Settings) {
      settings = callback(settings as T) as Settings;
    } else if (T == Prescription) {
      prescription = callback(prescription as T) as Prescription;
    }

    notifyListeners();
  }
}
