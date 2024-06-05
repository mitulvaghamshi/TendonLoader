import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tendon_loader/models/user.dart';
import 'package:tendon_loader/services/api/api_client.dart';
import 'package:tendon_loader/services/api/snapshot.dart';

@immutable
class UserService extends ApiClient {
  static final Map<int, User> _cache = {};

  Future<Snapshot<Iterable<User>>> getAll() async {
    if (_cache.isNotEmpty) return Snapshot.withData(_cache.values);
    final snapshot = await get('user');
    if (snapshot.hasData) {
      final list = List.from(snapshot.requireData).map(User.fromJson);
      _cache.addAll({for (final item in list) item.id!: item});
      return Snapshot.withData(list);
    }
    return Snapshot.withError(snapshot.error.toString());
  }

  Future<Snapshot<User>> getBy({required final int userId}) async {
    if (_cache.containsKey(userId)) return Snapshot.withData(_cache[userId]!);
    final snapshot = await get('user/$userId');
    if (snapshot.hasData) {
      final user = User.fromJson(snapshot.requireData);
      _cache.update(userId, (_) => user, ifAbsent: () => user);
      return Snapshot.withData(user);
    }
    return Snapshot.withError(snapshot.error.toString());
  }

  Future<Snapshot<User>> auth({
    required final String user,
    required final String pass,
  }) async {
    if (user.isEmpty || pass.isEmpty) {
      return const Snapshot.withError('Username or Password not provided');
    }
    // TODO(mitul): Change base64 encoding...
    final cred = base64Encode(utf8.encode('$user:$pass'));
    final snapshot = await get('user/auth/$cred');
    if (snapshot.hasData) {
      return Snapshot.withData(User.fromJson(snapshot.requireData));
    }
    return Snapshot.withError(snapshot.error.toString());
  }
}
