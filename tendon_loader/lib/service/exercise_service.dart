import 'package:api_server/api_server.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/api/api_client.dart';

@immutable
class const ExerciseService._(
  final ApiClient _client,
  final LocalCache _cache,
) {
  factory({ApiClient? client, LocalCache? cache}) =>
      client != null || cache != null
      ? ._(client ?? .new(), cache ?? .instance)
      : instance;

  static final instance = ExerciseService._(.new(), .instance);

  Future<Snapshot<Iterable<Exercise>>> getAllExercisesByUserId(int id) async {
    if (_cache.exercises.containsKey(id)) {
      return .data(_cache.exercises[id]!.values);
    }
    final snapshot = await _client.get(
      'api/exercises/user/$id',
      fromJson: ExerciseData.fromJson,
    );
    if (snapshot.data case final ExerciseData exerciseData) {
      final exercises = exerciseData.exercises;
      final values = {for (var item in exercises) item.id: item};
      _cache.exercises.update(id, (_) => values, ifAbsent: () => values);
      return .data(exercises);
    }
    return .error(snapshot.error);
  }

  Future<Snapshot<Exercise>> getExerciseBy({
    required int userId,
    required int exerciseId,
  }) async {
    if (_cache.exercises.containsKey(userId)) {
      final exercises = _cache.exercises[userId]!;
      if (exercises.containsKey(exerciseId)) {
        return .data(exercises[exerciseId]!);
      }
    }
    final snapshot = await _client.get(
      'api/exercises/$exerciseId',
      fromJson: Exercise.fromJson,
    );
    if (snapshot.data case final Exercise exercise) {
      _cache.exercises.update(userId, (v) {
        v.update(exerciseId, (_) => exercise, ifAbsent: () => exercise);
        return v;
      }, ifAbsent: () => {exerciseId: exercise});
      return .data(exercise);
    }
    return .error(snapshot.error);
  }

  Future<Snapshot<String>> createExercise(Exercise e) async {
    _cache.exercises.update(e.userId, (v) {
      v.update(e.id, (_) => e, ifAbsent: () => e);
      return v;
    }, ifAbsent: () => {e.id: e});
    final snapshot = await _client.post<String>('api/exercises', body: e.map);
    return snapshot.hasData
        ? .data(snapshot.requireData)
        : .error(snapshot.error);
  }

  Future<Snapshot<Never>> updateExercise(Exercise e) async {
    _cache.exercises.update(e.userId, (v) {
      v.update(e.id, (_) => e, ifAbsent: () => e);
      return v;
    }, ifAbsent: () => {e.id: e});
    final snapshot = await _client.put<Never>(
      'api/exercises/${e.id}',
      body: e.map,
    );
    return snapshot.hasData
        ? .data(snapshot.requireData)
        : .error(snapshot.error);
  }

  Future<Snapshot<Never>> deleteExerciseById({
    required int userId,
    required int exerciseId,
  }) async {
    _cache.exercises.update(userId, (v) {
      v.remove(exerciseId);
      return v;
    });
    final snapshot = await _client.delete<Never>('api/exercises/$exerciseId');
    return snapshot.hasData
        ? .data(snapshot.requireData)
        : .error(snapshot.error);
  }
}
