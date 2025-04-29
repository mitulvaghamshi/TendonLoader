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
    final snapshot = await get('users');
    if (snapshot.hasData) {
      final list = List<Map<String, dynamic>>.from(
        snapshot.requireData,
      ).map<User>(User.fromJson);
      _cache.addAll({for (var item in list) item.id!: item});
      return Snapshot.withData(list);
    }
    return Snapshot.withError(snapshot.error);
  }

  Future<Snapshot<User>> getUserById({required int userId}) async {
    if (_cache.containsKey(userId)) return Snapshot.withData(_cache[userId]!);
    final snapshot = await get('users/$userId');
    if (snapshot.hasData) {
      final user = User.fromJson(snapshot.requireData);
      _cache.update(userId, (_) => user, ifAbsent: () => user);
      return Snapshot.withData(user);
    }
    return Snapshot.withError(snapshot.error);
  }

  Future<Snapshot<User>> authenticate(User user) async {
    if (user.username.isEmpty || user.password.isEmpty) {
      return const Snapshot.withError('Opps!');
    }
    final cred = base64.encode(
      utf8.encode('${user.username}:${user.password}'),
    );
    final snapshot = await post('users/auth', {'credential': cred});
    if (snapshot.data case {'id': int id, 'token': int token}) {
      return Snapshot.withData(user.copyWith(id: id, token: token));
    }
    return Snapshot.withError(snapshot.error);
  }
}
