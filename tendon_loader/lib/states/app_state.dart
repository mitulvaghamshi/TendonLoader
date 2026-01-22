import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:server/models/prescription.dart';
import 'package:server/models/settings.dart';
import 'package:server/models/user.dart';
import 'package:server/utils/snapshot.dart';
import 'package:tendon_loader/api/api_client.dart';
import 'package:tendon_loader/api/services/prescription_service.dart';
import 'package:tendon_loader/api/services/settings_service.dart';
import 'package:tendon_loader/api/services/user_service.dart';

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
    if (sUser.data case User user) {
      authUser = user;
      ApiClient.token = user.token;
    }

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
