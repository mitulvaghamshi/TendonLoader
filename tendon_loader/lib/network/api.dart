import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:tendon_loader/network/api_client.dart';
import 'package:tendon_loader/network/exercise.dart';
import 'package:tendon_loader/network/prescription.dart';
import 'package:tendon_loader/network/settings.dart';
import 'package:tendon_loader/network/user.dart';

final class Api extends ChangeNotifier {
  Api.empty()
      : settings = const Settings.empty(),
        excercise = const Exercise.empty(),
        prescription = const Prescription.empty();

  User? user;
  Settings settings;
  Exercise excercise;
  Prescription prescription;
  String message = '';

  Future<void> authenticate({
    required final String username,
    required final String password,
  }) async {
    if (username.isEmpty || password.isEmpty) return;
    final cred = base64Encode(utf8.encode('$username:$password'));
    final (json, hasError) = await ApiClient.get('api/user/auth/$cred');
    if (hasError) {
      message = 'Unable to login, check your credentials.';
    } else {
      user = User.fromJson(json);
    }
    notifyListeners();
  }

  Future<void> getSettings({required final int userId}) async {
    final (json, hasError) = await ApiClient.get('api/settings/user/$userId');
    if (hasError) {
      message = 'Unable to load Settings.';
    } else {
      settings = Settings.fromJson(json);
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

  Future<void> getExercise({required final int exerciseId}) async {
    final (json, hasError) = await ApiClient.get('api/exercise/$exerciseId');
    if (hasError) {
      message = 'Unable to load Exercise.';
    } else {
      excercise = Exercise.fromJson(json);
    }
    notifyListeners();
  }

  Future<Iterable<Exercise>> getExercisesFor({
    required final int userId,
  }) async {
    final (json, hasError) = await ApiClient.get('api/exercise/user/$userId');
    if (hasError) return [];
    return List.from(json).map(Exercise.fromJson);
  }

  void update<T>(T Function(T settings) send) {
    settings = send(settings as T) as Settings;
    notifyListeners();
  }
}
