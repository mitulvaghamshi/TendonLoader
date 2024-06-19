import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/api/api_client.dart';
import 'package:tendon_loader/api/snapshot.dart';
import 'package:tendon_loader/models/user.dart';

@immutable
class UserService extends ApiClient {
  factory UserService() => const UserService._();

  const UserService._();

  static final UserService _instance = UserService();
  static UserService get instance => _instance;

  static final Map<int, User> _cache = {};

  Future<Snapshot<Iterable<User>>> getAllUsers() async {
    if (_cache.isNotEmpty) return Snapshot.withData(_cache.values);
    final snapshot = await get('user');
    if (snapshot.hasData) {
      final list = List.from(snapshot.requireData).map(User.fromJson);
      _cache.addAll({for (final item in list) item.id!: item});
      return Snapshot.withData(list);
    }
    return Snapshot.withError(snapshot.error);
  }

  Future<Snapshot<User>> getUserById({required final int userId}) async {
    if (_cache.containsKey(userId)) return Snapshot.withData(_cache[userId]!);
    final snapshot = await get('user/$userId');
    if (snapshot.hasData) {
      final user = User.fromJson(snapshot.requireData);
      _cache.update(userId, (_) => user, ifAbsent: () => user);
      return Snapshot.withData(user);
    }
    return Snapshot.withError(snapshot.error);
  }

  Future<Snapshot<User>> authenticate({
    required final String username,
    required final String password,
  }) async {
    if (username.isEmpty || password.isEmpty) {
      return const Snapshot.withError('Username or Password not provided');
    }
    // TODO(mitul): Change base64 encoding
    final cred = base64Encode(utf8.encode('$username:$password'));
    final snapshot = await get('user/auth/$cred');
    if (snapshot.hasData) {
      return Snapshot.withData(User.fromJson(snapshot.requireData));
    }
    return Snapshot.withError(snapshot.error);
  }
}
