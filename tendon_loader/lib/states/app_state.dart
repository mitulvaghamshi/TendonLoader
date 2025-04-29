import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:tendon_loader/models/prescription.dart';
import 'package:tendon_loader/models/settings.dart';
import 'package:tendon_loader/models/user.dart';
import 'package:tendon_loader/services/prescription_service.dart';
import 'package:tendon_loader/services/settings_service.dart';
import 'package:tendon_loader/services/user_service.dart';

class AppState extends ChangeNotifier {
  AppState()
    : authUser = const User.empty(),
      settings = const Settings.empty(),
      prescription = const Prescription.empty();

  User authUser;
  Settings settings;
  Prescription prescription;

  bool modified = false;

  Future<void> authenticate(User user) async {
    final sUser = await UserService.instance.authenticate(user);
    if (sUser.hasData) authUser = sUser.requireData;

    final sSettings = await SettingsService.instance.getSettingsBy(
      userId: authUser.id,
    );
    if (sUser.hasData) settings = sSettings.requireData;

    final prescriptionRes = await PrescriptionService.instance
        .getPrescriptionById(settings.prescriptionId);
    if (prescriptionRes.hasData) prescription = prescriptionRes.requireData;

    notifyListeners();
  }

  void update<T>(T Function(T state) callback) {
    if (T == Settings) {
      settings = callback(settings as T) as Settings;
    } else if (T == Prescription) {
      prescription = callback(prescription as T) as Prescription;
    }
    modified = true;

    notifyListeners();
  }
}
