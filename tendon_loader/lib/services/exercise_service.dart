import 'package:flutter/material.dart';
import 'package:tendon_loader/models/exercise.dart';
import 'package:tendon_loader/services/api/api_client.dart';

@immutable
final class ExerciseService extends ApiClient {
  static final Map<int, Map<int, Exercise>> _cache = {};

  Future<Iterable<Exercise>> getAll({
    required final int userId,
  }) async {
    if (_cache.containsKey(userId)) return _cache[userId]!.values;
    final result = await get('exercise/user/$userId');
    if (result.hasError) {
      debugPrint(result.error.toString());
      throw 'Requested resource not found.';
    }
    final list = List.from(result.requireData).map(Exercise.fromJson);
    final map = {for (final item in list) item.id: item};
    return _cache.putIfAbsent(userId, () => map).values;
  }

  Future<Exercise?> getBy({
    required final int userId,
    required final int exerciseId,
  }) async {
    if (_cache.containsKey(userId)) return _cache[userId]![exerciseId];
    final result = await get('exercise/$exerciseId');
    if (result.hasError) {
      debugPrint(result.error.toString());
      return null;
    }
    final exercise = Exercise.fromJson(result.requireData);
    _cache.update(userId, (map) {
      map.update(exerciseId, (_) => exercise, ifAbsent: () => exercise);
      return map;
    }, ifAbsent: () => {exerciseId: exercise});
    return exercise;
  }

  Future<void> create(final Exercise exercise) async {
    _cache.putIfAbsent(exercise.userId, () => {exercise.id: exercise});
    final result = await post('exercise', exercise.json);
    if (result.hasError) {
      debugPrint(result.error.toString());
      throw 'Unable to create Exercise';
    }
    debugPrint(result.requireData);
  }

  Future<void> update(final Exercise exercise) async {
    _cache.update(exercise.userId, (map) {
      map.update(exercise.id, (_) => exercise, ifAbsent: () => exercise);
      return map;
    }, ifAbsent: () => {exercise.id: exercise});
    final result = await put('exercise/${exercise.id}', exercise.json);
    if (result.hasError) {
      debugPrint(result.error.toString());
      throw 'Unable to update Exercise.';
    }
    debugPrint(result.requireData);
  }

  Future<void> deleteBy({required final int id}) async {
    if (_cache.containsKey(id)) _cache.remove(id);
    final result = await delete('exercise/$id');
    if (result.hasError) {
      debugPrint(result.error.toString());
      throw 'Unable to delete Exercise.';
    }
    debugPrint(result.requireData);
  }
}
