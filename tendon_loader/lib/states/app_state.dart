import 'package:flutter/foundation.dart';
import 'package:tendon_loader/api/services/settings_service.dart';
import 'package:tendon_loader/models/prescription.dart';
import 'package:tendon_loader/models/settings.dart';
import 'package:tendon_loader/models/user.dart';

final class AppState extends ChangeNotifier {
  AppState()
      : settings = const Settings.empty(),
        prescription = const Prescription.empty();

  User? user;
  Settings settings;
  Prescription prescription;
  bool modified = false;

  Future<void> setUser(final User? newUser) async {
    user = newUser;
    settings = await SettingsService.get(userId: user!.id!);
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
