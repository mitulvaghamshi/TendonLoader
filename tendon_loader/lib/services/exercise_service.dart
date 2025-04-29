import 'package:flutter/material.dart';
import 'package:tendon_loader/api/api_client.dart';
import 'package:tendon_loader/api/snapshot.dart';
import 'package:tendon_loader/models/exercise.dart';

@immutable
class ExerciseService extends ApiClient {
  factory ExerciseService() => const ExerciseService._();

  const ExerciseService._();

  static final ExerciseService _instance = ExerciseService();
  static ExerciseService get instance => _instance;

  static final Map<int, Map<int, Exercise>> _cache = {};

  Future<Snapshot<Iterable<Exercise>>> getAllExercisesByUserId(int id) async {
    if (_cache.containsKey(id)) return Snapshot.withData(_cache[id]!.values);
    final snapshot = await get('exercises/user/$id');
    if (snapshot.hasData) {
      final list = List<Map<String, dynamic>>.from(
        snapshot.requireData,
      ).map<Exercise>(Exercise.fromJson);
      final map = {for (var item in list) item.id: item};
      _cache.putIfAbsent(id, () => map).values;
      return Snapshot.withData(list);
    }
    return Snapshot.withError(snapshot.error);
  }

  Future<Snapshot<Exercise>> getExerciseBy({
    required int userId,
    required int exerciseId,
  }) async {
    if (_cache.containsKey(userId)) {
      final exercises = _cache[userId]!;
      if (exercises.containsKey(exerciseId)) {
        return Snapshot.withData(exercises[exerciseId]!);
      }
    }
    final snapshot = await get('exercises/$exerciseId');
    if (snapshot.hasData) {
      final exercise = Exercise.fromJson(snapshot.requireData);
      _cache.update(userId, (map) {
        map.update(exerciseId, (_) => exercise, ifAbsent: () => exercise);
        return map;
      }, ifAbsent: () => {exerciseId: exercise});
      return Snapshot.withData(exercise);
    }
    return Snapshot.withError(snapshot.error);
  }

  Future<Snapshot> createExercise(Exercise exercise) async {
    _cache.putIfAbsent(exercise.userId, () => {exercise.id: exercise});
    final snapshot = await post('exercises', exercise.json);
    if (snapshot.hasData) return Snapshot.withData(snapshot.requireData);
    return Snapshot.withError(snapshot.error);
  }

  Future<Snapshot> updateExercise(Exercise exercise) async {
    _cache.update(exercise.userId, (map) {
      map.update(exercise.id, (_) => exercise, ifAbsent: () => exercise);
      return map;
    }, ifAbsent: () => {exercise.id: exercise});
    final snapshot = await put('exercises/${exercise.id}', exercise.json);
    if (snapshot.hasData) return Snapshot.withData(snapshot.requireData);
    return Snapshot.withError(snapshot.error);
  }

  Future<Snapshot> deleteExerciseById(int id) async {
    if (_cache.containsKey(id)) _cache.remove(id);
    final snapshot = await delete('exercises/$id');
    if (snapshot.hasData) return Snapshot.withData(snapshot.requireData);
    return Snapshot.withError(snapshot.error);
  }
}
