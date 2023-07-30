import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:tendon_loader/clinicial/user.dart';
import 'package:tendon_loader/network/api_client.dart';
import 'package:tendon_loader/prescription/prescription.dart';
import 'package:tendon_loader/settings/settings.dart';
import 'package:tendon_loader/settings/settings_service.dart';

final class AppState extends ChangeNotifier {
  AppState()
      : settings = const Settings.empty(),
        prescription = const Prescription.empty();

  User? user;
  Settings settings;
  Prescription prescription;
  bool modified = false;

  Future<void> authenticate({
    required final String username,
    required final String password,
  }) async {
    if (username.isEmpty || password.isEmpty) return;
    final cred = base64Encode(utf8.encode('$username:$password'));
    final (json, hasError) = await ApiClient.get('user/auth/$cred');
    if (hasError) {
      throw 'Unable to login, check your credentials.';
    } else {
      user = User.fromJson(json);
      settings = await SettingsService.get(userId: user!.id!);
    }
    notifyListeners();
  }

  void get<T>(final T Function(T state) get) {
    modified = true;
    if (T == Settings) {
      settings = get(settings as T) as Settings;
    } else if (T == Prescription) {
      prescription = get(prescription as T) as Prescription;
    }
    notifyListeners();
  }
}
