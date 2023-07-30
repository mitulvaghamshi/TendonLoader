import 'package:flutter/material.dart';
import 'package:tendon_loader/exercise/exercise.dart';
import 'package:tendon_loader/network/api_client.dart';

@immutable
mixin ExerciseService {
  static final Map<int, Map<int, Exercise>> _cache = {};

  static Future<Iterable<Exercise>> getAllBy({
    required final int userId,
  }) async {
    if (_cache.containsKey(userId)) return _cache[userId]!.values;
    final (json, hasError) = await ApiClient.get('exercise/user/$userId');
    if (hasError) throw 'Not found...';
    final list = List.from(json).map(Exercise.fromJson);
    final map = {for (final item in list) item.id: item};
    return _cache.putIfAbsent(userId, () => map).values;
  }

  static Future<Exercise?> get({
    required final int userId,
    required final int exerciseId,
  }) async {
    if (_cache.containsKey(userId)) return _cache[userId]![exerciseId];
    final (json, hasError) = await ApiClient.get('exercise/$exerciseId');
    if (hasError) return null;
    final exercise = Exercise.fromJson(json);
    _cache.update(userId, (map) {
      map.update(exerciseId, (_) => exercise, ifAbsent: () => exercise);
      return map;
    }, ifAbsent: () => {exerciseId: exercise});
    return exercise;
  }

  static Future<void> create(final Exercise exercise) async {
    _cache.putIfAbsent(exercise.userId, () => {exercise.id: exercise});
    final (json, error) = await ApiClient.post('exercise', exercise.json);
    if (error) throw 'Unable to create Exercise';
    print(json);
  }

  static Future<void> update(final Exercise exercise) async {
    _cache.update(exercise.userId, (map) {
      map.update(exercise.id, (_) => exercise, ifAbsent: () => exercise);
      return map;
    }, ifAbsent: () => {exercise.id: exercise});
    final (json, error) =
        await ApiClient.put('exercise/${exercise.id}', exercise.json);
    if (error) throw 'Unable to update Exercise.';
    print(json);
  }

  static Future<void> delete({required final int id}) async {
    if (_cache.containsKey(id)) _cache.remove(id);
    final (json, error) = await ApiClient.delete('exercise/$id');
    if (error) throw 'Unable to delete Exercise.';
    print(json);
  }
}
