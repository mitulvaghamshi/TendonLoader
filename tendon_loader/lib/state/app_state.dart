import 'dart:async';

import 'package:api_server/api_server.dart';
import 'package:flutter/foundation.dart';
import 'package:tendon_loader/api/api_client.dart';
import 'package:tendon_loader/service/prescription_service.dart';
import 'package:tendon_loader/service/settings_service.dart';
import 'package:tendon_loader/service/user_service.dart';

class AppState._({
  required var User authUser,
  required var Settings settings,
  required var Prescription prescription,
}) extends ChangeNotifier {
  factory() =>
      ._(authUser: .empty(), settings: .empty(), prescription: .empty());

  bool modified = false;

  bool get isAuthenticated => authUser.token != null;

  Future<String> authenticate(User user) async {
    final userSnapshot = await UserService.instance.authenticate(user);
    if (userSnapshot.data case final User user) {
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
    } else if (T == Prescription) {
      modified = true;
      prescription = apply(prescription as T) as Prescription;
    } else {
      throw UnimplementedError('Type: $T is not implemented!');
    }

    if (modified) {
      notifyListeners();
    }
  }
}
