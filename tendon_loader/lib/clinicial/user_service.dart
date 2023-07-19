import 'package:flutter/material.dart';
import 'package:tendon_loader/clinicial/user.dart';
import 'package:tendon_loader/network/api_client.dart';

@immutable
mixin UserService {
  static final Map<int, User> _cache = {};

  static Future<Iterable<User>> getAll() async {
    if (_cache.isNotEmpty) return _cache.values;
    final (json, hasError) = await ApiClient.get('user');
    if (hasError) return [];
    final list = List.from(json).map(User.fromJson);
    _cache.addAll({for (final item in list) item.id!: item});
    return list;
  }

  static Future<User> getBy({required final int userId}) async {
    if (_cache.containsKey(userId)) return _cache[userId]!;
    final (json, hasError) = await ApiClient.get('user/$userId');
    if (hasError) throw 'Not Found';
    final user = User.fromJson(json);
    return _cache.update(userId, (value) => user, ifAbsent: () => user);
  }
}
