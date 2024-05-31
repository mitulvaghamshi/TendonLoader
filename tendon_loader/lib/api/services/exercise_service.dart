import 'package:flutter/material.dart';
import 'package:tendon_loader/models/exercise.dart';
import 'package:tendon_loader/api/api_client.dart';

@immutable
mixin ExerciseService {
  static final Map<int, Map<int, Exercise>> _cache = {};

  static Future<Iterable<Exercise>> getAllBy({
    required final int userId,
  }) async {
    if (_cache.containsKey(userId)) return _cache[userId]!.values;
    final result = await ApiClient.get('exercise/user/$userId');
    if (result.hasError) {
      debugPrint(result.error!.message);
      throw 'Requested resource not found.';
    }
    final list = List.from(result.data!.content).map(Exercise.fromJson);
    final map = {for (final item in list) item.id: item};
    return _cache.putIfAbsent(userId, () => map).values;
  }

  static Future<Exercise?> get({
    required final int userId,
    required final int exerciseId,
  }) async {
    if (_cache.containsKey(userId)) return _cache[userId]![exerciseId];
    final result = await ApiClient.get('exercise/$exerciseId');
    if (result.hasError) {
      debugPrint(result.error!.message);
      return null;
    }
    final exercise = Exercise.fromJson(result.data!.content);
    _cache.update(userId, (map) {
      map.update(exerciseId, (_) => exercise, ifAbsent: () => exercise);
      return map;
    }, ifAbsent: () => {exerciseId: exercise});
    return exercise;
  }

  static Future<void> create(final Exercise exercise) async {
    _cache.putIfAbsent(exercise.userId, () => {exercise.id: exercise});
    final result = await ApiClient.post('exercise', exercise.json);
    if (result.hasError) {
      debugPrint(result.error!.message);
      throw 'Unable to create Exercise';
    }
    debugPrint(result.data!.content);
  }

  static Future<void> update(final Exercise exercise) async {
    _cache.update(exercise.userId, (map) {
      map.update(exercise.id, (_) => exercise, ifAbsent: () => exercise);
      return map;
    }, ifAbsent: () => {exercise.id: exercise});
    final result = await ApiClient.put(
      'exercise/${exercise.id}',
      exercise.json,
    );
    if (result.hasError) {
      debugPrint(result.error!.message);
      throw 'Unable to update Exercise.';
    }
    debugPrint(result.data!.content);
  }

  static Future<void> delete({required final int id}) async {
    if (_cache.containsKey(id)) _cache.remove(id);
    final result = await ApiClient.delete('exercise/$id');
    if (result.hasError) {
      debugPrint(result.error!.message);
      throw 'Unable to delete Exercise.';
    }
    debugPrint(result.data!.content);
  }
}
