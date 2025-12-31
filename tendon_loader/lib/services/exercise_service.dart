import 'package:flutter/material.dart';
import 'package:tendon_loader/api/api_client.dart';
import 'package:tendon_loader/api/snapshot.dart';
import 'package:tendon_loader/models/exercise.dart';

@immutable
class ExerciseService with ApiClient {
  factory ExerciseService() => instance;

  const ExerciseService._();

  static const _instance = ExerciseService._();
  static ExerciseService get instance => _instance;

  static final Map<int, Map<int, Exercise>> _cache = {};
}

extension Utils on ExerciseService {
  Future<Snapshot<Iterable<Exercise>>> getAllExercisesByUserId(int id) async {
    if (ExerciseService._cache.containsKey(id)) {
      return .data(ExerciseService._cache[id]!.values);
    }
    final snapshot = await get('exercises/user/$id');
    if (snapshot.hasData) {
      final items = List<Map<String, dynamic>>.from(snapshot.requireData);
      final exercises = items.map(Exercise.fromJson);
      final values = {for (var item in exercises) item.id: item};
      ExerciseService._cache.putIfAbsent(id, () => values);
      return .data(exercises);
    }
    return .error(snapshot.error);
  }

  Future<Snapshot<Exercise>> getExerciseBy({
    required int userId,
    required int exerciseId,
  }) async {
    if (ExerciseService._cache.containsKey(userId)) {
      final exercises = ExerciseService._cache[userId]!;
      if (exercises.containsKey(exerciseId)) {
        return .data(exercises[exerciseId]!);
      }
    }
    final snapshot = await get('exercises/$exerciseId');
    if (snapshot.hasData) {
      final exercise = Exercise.fromJson(snapshot.requireData);
      ExerciseService._cache.update(userId, (values) {
        values.update(exerciseId, (_) => exercise, ifAbsent: () => exercise);
        return values;
      }, ifAbsent: () => {exerciseId: exercise});
      return .data(exercise);
    }
    return .error(snapshot.error);
  }

  Future<Snapshot<String>> createExercise(Exercise exercise) async {
    ExerciseService._cache.putIfAbsent(
      exercise.userId,
      () => {exercise.id: exercise},
    );
    final snapshot = await post('exercises', values: exercise.map);
    if (snapshot.hasData) {
      return .data(snapshot.requireData);
    }
    return .error(snapshot.error);
  }

  Future<Snapshot<Never>> updateExercise(Exercise exercise) async {
    ExerciseService._cache.update(exercise.userId, (values) {
      values.update(exercise.id, (_) => exercise, ifAbsent: () => exercise);
      return values;
    }, ifAbsent: () => {exercise.id: exercise});
    final snapshot = await put(
      'exercises/${exercise.id}',
      values: exercise.map,
    );
    if (snapshot.hasData) {
      return .data(snapshot.requireData);
    }
    return .error(snapshot.error);
  }

  Future<Snapshot<Never>> deleteExerciseById(int id) async {
    if (ExerciseService._cache.containsKey(id)) {
      ExerciseService._cache.remove(id);
    }
    final snapshot = await delete('exercises/$id');
    if (snapshot.hasData) {
      return .data(snapshot.requireData);
    }
    return .error(snapshot.error);
  }
}
