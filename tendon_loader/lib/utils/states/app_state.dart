import 'package:flutter/foundation.dart';
import 'package:tendon_loader/models/prescription.dart';
import 'package:tendon_loader/models/settings.dart';
import 'package:tendon_loader/models/user.dart';
import 'package:tendon_loader/services/settings_service.dart';
import 'package:tendon_loader/services/user_service.dart';

final class AppState extends ChangeNotifier {
  AppState({required this.userService, required this.settingsService})
      : settings = const Settings.empty(),
        prescription = const Prescription.empty();

  User? user;
  Settings settings;
  Prescription prescription;
  bool modified = false;

  final UserService userService;
  final SettingsService settingsService;

  Future<void> authenticate({
    required final String username,
    required final String password,
  }) async {
    user = await userService.authenticate(
      username: username,
      password: password,
    );
    settings = await settingsService.getBy(userId: user!.id!);
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
