import 'package:flutter/foundation.dart';
import 'package:tendon_loader/models/prescription.dart';
import 'package:tendon_loader/models/settings.dart';
import 'package:tendon_loader/models/user.dart';
import 'package:tendon_loader/services/prescription_service.dart';
import 'package:tendon_loader/services/settings_service.dart';
import 'package:tendon_loader/services/user_service.dart';

class AppState extends ChangeNotifier {
  AppState()
      : user = const User.empty(),
        settings = const Settings.empty(),
        prescription = const Prescription.empty();

  User user;
  Settings settings;
  Prescription prescription;

  bool modified = false;

  Future<void> authenticate({
    required final String username,
    required final String password,
  }) async {
    final uSnapshot = await UserService.instance
        .authenticate(username: username, password: password);
    if (uSnapshot.hasData) user = uSnapshot.requireData;

    final sSnapshot =
        await SettingsService.instance.getSettingsByUserId(user.id);
    if (uSnapshot.hasData) settings = sSnapshot.requireData;

    final pSnapshot = await PrescriptionService.instance
        .getPrescriptionById(settings.prescriptionId);
    if (pSnapshot.hasData) prescription = pSnapshot.requireData;

    notifyListeners();
  }

  void update<T>(final T Function(T state) callback) {
    if (T == Settings) {
      settings = callback(settings as T) as Settings;
    } else if (T == Prescription) {
      prescription = callback(prescription as T) as Prescription;
    }
    modified = true;

    notifyListeners();
  }
}
