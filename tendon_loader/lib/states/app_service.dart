import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:tendon_loader/app_user/user.dart';
import 'package:tendon_loader/models/exercise.dart';
import 'package:tendon_loader/models/prescription.dart';
import 'package:tendon_loader/network/api_client.dart';
import 'package:tendon_loader/settings/settings.dart';
import 'package:tendon_loader/settings/settings_service.dart';

final class AppService extends ChangeNotifier {
  AppService.empty()
      : settings = const Settings.empty(),
        excercise = const Exercise.empty(),
        prescription = const Prescription.empty(),
        userList = const [];

  User? user;
  Settings settings;
  Exercise excercise;
  Prescription prescription;
  Iterable<User> userList;

  String message = '';
  bool modified = false;

  final Map<int, Iterable<Exercise>> _cache = {};

  Future<void> authenticate({
    required final String username,
    required final String password,
  }) async {
    if (username.isEmpty || password.isEmpty) return;
    final cred = base64Encode(utf8.encode('$username:$password'));
    final (json, hasError) = await ApiClient.get('user/auth/$cred');
    if (hasError) {
      message = 'Unable to login, check your credentials.';
    } else {
      user = User.fromJson(json);
      settings = await SettingsService.fetch(userId: user!.id!);
    }
    notifyListeners();
  }

  Future<void> getPrescription({
    required final int prescriptionId,
    required final Category category,
  }) async {
    final (json, hasError) = await ApiClient.get(
      'api/prescription/$category/$prescriptionId',
    );
    if (hasError) {
      message = 'Unable to load Prescription.';
    } else {
      prescription = Prescription.fromJson(json);
    }
    notifyListeners();
  }

  Future<bool> getUserList() async {
    if (userList.isNotEmpty) return true;
    final (json, hasError) = await ApiClient.get('user');
    if (hasError) return false;
    userList = List.from(json).map(User.fromJson);
    notifyListeners();
    return true;
  }

  Future<Iterable<Exercise>> getExerciseList({
    required final int userId,
  }) async {
    if (_cache.containsKey(userId)) return _cache[userId]!;
    final (json, hasError) = await ApiClient.get('exercise/user/$userId');
    if (hasError) return [];
    return _cache.putIfAbsent(userId, () {
      return List.from(json).map(Exercise.fromJson);
    });
  }

  Future<void> getExerciseBy({required final int exerciseId}) async {
    final (json, hasError) = await ApiClient.get('exercise/$exerciseId');
    if (hasError) {
      message = 'Unable to load Exercise.';
    } else {
      excercise = Exercise.fromJson(json);
    }
    notifyListeners();
  }

  void get<T>(final T Function(T state) get) {
    modified = true;
    if (T == Settings) {
      settings = get(settings as T) as Settings;
    }
    notifyListeners();
  }
}
