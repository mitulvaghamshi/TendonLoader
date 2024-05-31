import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tendon_loader/api/api_client.dart';
import 'package:tendon_loader/models/user.dart';

@immutable
mixin UserService {
  static final Map<int, User> _cache = {};

  static Future<Iterable<User>> getAll() async {
    if (_cache.isNotEmpty) return _cache.values;
    final result = await ApiClient.get('user');
    if (result.hasError) {
      debugPrint(result.error!.message);
      return [];
    }
    final list = List.from(result.data!.content).map(User.fromJson);
    _cache.addAll({for (final item in list) item.id!: item});
    return list;
  }

  static Future<User> getBy({required final int userId}) async {
    if (_cache.containsKey(userId)) return _cache[userId]!;
    final result = await ApiClient.get('user/$userId');
    if (result.hasError) {
      debugPrint(result.error!.message);
      throw 'Requested resource not found.';
    }
    final user = User.fromJson(result.data!.content);
    return _cache.update(userId, (_) => user, ifAbsent: () => user);
  }

  static Future<User?> authenticate({
    required final String username,
    required final String password,
  }) async {
    if (username.isEmpty || password.isEmpty) return null;
    // TODO(mitul): Change base64 encoding...
    final cred = base64Encode(utf8.encode('$username:$password'));
    final result = await ApiClient.get('user/auth/$cred');
    if (result.hasData) return User.fromJson(json);
    debugPrint(result.error!.message);
    throw 'Unable to login.';
  }
}
