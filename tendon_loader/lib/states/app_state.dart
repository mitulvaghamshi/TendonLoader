import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:tendon_loader/api/services/prescription_service.dart';
import 'package:tendon_loader/api/services/settings_service.dart';
import 'package:tendon_loader/api/services/user_service.dart';
import 'package:tendon_loader/api/snapshot.dart';
import 'package:tendon_loader/models/prescription.dart';
import 'package:tendon_loader/models/settings.dart';
import 'package:tendon_loader/models/user.dart';

class AppState extends ChangeNotifier {
  AppState()
    : authUser = const .empty(),
      settings = const .empty(),
      prescription = const .empty();

  User authUser;
  Settings settings;
  Prescription prescription;

  bool modified = false;

  bool get isAuthenticated => authUser.token != null;

  Future<String> authenticate(User user) async {
    final sUser = await UserService.instance.authenticate(user);
    if (!sUser.hasData || sUser.hasError) {
      return '[User/auth]: ${sUser.error}';
    }
    authUser = sUser.requireData;

    final sSettings = await SettingsService.instance.getSettingsBy(
      userId: ArgumentError.checkNotNull(authUser.id),
    );
    if (!sSettings.hasData || sSettings.hasError) {
      return '[Settings/auth]: ${sSettings.error}';
    }
    settings = sSettings.requireData;

    final sPrescription = await PrescriptionService.instance
        .getPrescriptionById(settings.prescriptionId);
    if (!sPrescription.hasData || sPrescription.hasError) {
      return '[Prescription/auth]: ${sSettings.error}';
    }
    prescription = sPrescription.requireData;

    notifyListeners();

    return 'Login Successfull!';
  }

  void update<T>(T Function(T state) apply) {
    modified = false;

    if (T == Settings) {
      modified = true;
      settings = apply(settings as T) as Settings;
    }

    if (T == Prescription) {
      modified = true;
      prescription = apply(prescription as T) as Prescription;
    }

    if (modified) {
      notifyListeners();
    }
  }
}
