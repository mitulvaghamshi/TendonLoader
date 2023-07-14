import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:tendon_loader/signin/user.dart';
import 'package:tendon_loader/models/chartdata.dart';
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

  final Map<int, Iterable<Exercise>> _cacheExerciseListForUser = {};
  final Map<int, Prescription> _cachePrescriptionForExercise = {};

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

  Future<void> getUserList() async {
    if (userList.isNotEmpty) return;
    final (json, hasError) = await ApiClient.get('user');
    if (hasError) return;
    userList = List.from(json).map(User.fromJson);
    notifyListeners();
  }

  Future<Iterable<Exercise>> getExerciseList({
    required final int userId,
  }) async {
    if (_cacheExerciseListForUser.containsKey(userId)) {
      return _cacheExerciseListForUser[userId]!;
    }
    final (json, hasError) = await ApiClient.get('exercise/user/$userId');
    if (hasError) return [];
    return _cacheExerciseListForUser.putIfAbsent(userId, () {
      return List.from(json).map(Exercise.fromJson);
    });
  }

  Future<Iterable<ChartData>> getExerciseDataList({
    required final int userId,
    required final int exerciseId,
  }) async {
    if (_cacheExerciseListForUser.containsKey(userId)) {
      return _cacheExerciseListForUser[userId]!
          .firstWhere((e) => e.id == exerciseId)
          .data;
    }
    final (json, hasError) = await ApiClient.get('exercise/$exerciseId');
    if (hasError) return [];
    return Exercise.fromJson(json).data;
  }

  Future<(Exercise?, Prescription?)> getExerciseAndPrescription({
    required final int userId,
    required final int exerciseId,
  }) async {
    late final Exercise exercise;
    if (_cacheExerciseListForUser.containsKey(userId)) {
      exercise = _cacheExerciseListForUser[userId]!
          .firstWhere((e) => e.id == exerciseId);
    } else {
      final (json, hasError) = await ApiClient.get('exercise/$exerciseId');
      if (hasError) return (null, null);
      exercise = Exercise.fromJson(json);
    }
    if (excercise.isMVC) return (exercise, null);
    final prescriptionId = exercise.prescriptionId;
    if (prescriptionId == null) return (exercise, null);
    final prescription = await getPrescriptionFor(
        exerciseId: exerciseId, prescriptionId: prescriptionId);
    return (exercise, prescription);
  }

  Future<Prescription?> getPrescriptionFor({
    required final int exerciseId,
    required final int prescriptionId,
  }) async {
    if (_cachePrescriptionForExercise.containsKey(exerciseId)) {
      return _cachePrescriptionForExercise[exerciseId]!;
    }
    final (json, hasError) =
        await ApiClient.get('prescription/$prescriptionId');
    if (hasError) return null;
    return _cachePrescriptionForExercise.putIfAbsent(
        exerciseId, () => Prescription.fromJson(json));
  }

  void get<T>(final T Function(T state) get) {
    modified = true;
    if (T == Settings) {
      settings = get(settings as T) as Settings;
    }
    notifyListeners();
  }
}
