import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tendon_loader/models/user.dart';
import 'package:tendon_loader/services/api/api_client.dart';

@immutable
final class UserService extends ApiClient {
  static final Map<int, User> _cache = {};

  Future<Iterable<User>> getAll() async {
    if (_cache.isNotEmpty) return _cache.values;
    final snapshot = await get('user');
    if (snapshot.hasError) {
      debugPrint(snapshot.error.toString());
      return [];
    }
    final list = List.from(snapshot.requireData).map(User.fromJson);
    _cache.addAll({for (final item in list) item.id!: item});
    return list;
  }

  Future<User> getBy({required final int userId}) async {
    if (_cache.containsKey(userId)) return _cache[userId]!;
    final snapshot = await get('user/$userId');
    if (snapshot.hasError) {
      debugPrint(snapshot.error.toString());
      throw 'Requested resource not found.';
    }
    final user = User.fromJson(snapshot.requireData);
    return _cache.update(userId, (_) => user, ifAbsent: () => user);
  }

  Future<User?> authenticate({
    required final String username,
    required final String password,
  }) async {
    if (username.isEmpty || password.isEmpty) return null;
    // TODO(mitul): Change base64 encoding...
    final cred = base64Encode(utf8.encode('$username:$password'));
    final snapshot = await get('user/auth/$cred');
    if (snapshot.hasData) return User.fromJson(snapshot.requireData);
    debugPrint(snapshot.error.toString());
    throw 'Unable to login.';
  }
}
