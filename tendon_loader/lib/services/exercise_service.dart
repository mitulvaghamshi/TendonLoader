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
      return Snapshot.withData(ExerciseService._cache[id]!.values);
    }
    final snapshot = await get('exercises/user/$id');
    if (snapshot.hasData) {
      final list = List<Map<String, dynamic>>.from(
        snapshot.requireData,
      ).map<Exercise>(Exercise.fromJson);
      final map = {for (var item in list) item.id: item};
      ExerciseService._cache.putIfAbsent(id, () => map).values;
      return Snapshot.withData(list);
    }
    return Snapshot.withError(snapshot.error);
  }

  Future<Snapshot<Exercise>> getExerciseBy({
    required int userId,
    required int exerciseId,
  }) async {
    if (ExerciseService._cache.containsKey(userId)) {
      final exercises = ExerciseService._cache[userId]!;
      if (exercises.containsKey(exerciseId)) {
        return Snapshot.withData(exercises[exerciseId]!);
      }
    }
    final snapshot = await get('exercises/$exerciseId');
    if (snapshot.hasData) {
      final exercise = Exercise.fromJson(snapshot.requireData);
      ExerciseService._cache.update(userId, (map) {
        map.update(exerciseId, (_) => exercise, ifAbsent: () => exercise);
        return map;
      }, ifAbsent: () => {exerciseId: exercise});
      return Snapshot.withData(exercise);
    }
    return Snapshot.withError(snapshot.error);
  }

  Future<Snapshot> createExercise(Exercise exercise) async {
    ExerciseService._cache.putIfAbsent(
      exercise.userId,
      () => {exercise.id: exercise},
    );
    final snapshot = await post('exercises', exercise.json);
    if (snapshot.hasData) {
      return Snapshot.withData(snapshot.requireData);
    }
    return Snapshot.withError(snapshot.error);
  }

  Future<Snapshot> updateExercise(Exercise exercise) async {
    ExerciseService._cache.update(exercise.userId, (map) {
      map.update(exercise.id, (_) => exercise, ifAbsent: () => exercise);
      return map;
    }, ifAbsent: () => {exercise.id: exercise});
    final snapshot = await put('exercises/${exercise.id}', exercise.json);
    if (snapshot.hasData) {
      return Snapshot.withData(snapshot.requireData);
    }
    return Snapshot.withError(snapshot.error);
  }

  Future<Snapshot> deleteExerciseById(int id) async {
    if (ExerciseService._cache.containsKey(id)) {
      ExerciseService._cache.remove(id);
    }
    final snapshot = await delete('exercises/$id');
    if (snapshot.hasData) {
      return Snapshot.withData(snapshot.requireData);
    }
    return Snapshot.withError(snapshot.error);
  }
}
