import 'dart:convert' show base64, utf8;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tendon_loader/api/api_client.dart';
import 'package:tendon_loader/api/snapshot.dart';
import 'package:tendon_loader/models/user.dart';

@immutable
class UserService with ApiClient {
  factory UserService() => instance;

  const UserService._();

  static const _instance = UserService._();
  static UserService get instance => _instance;

  static final Map<int, User> _cache = {};
}

extension Utils on UserService {
  Future<Snapshot<Iterable<User>>> getAllUsers() async {
    if (UserService._cache.isNotEmpty) {
      return Snapshot.withData(UserService._cache.values);
    }
    final snapshot = await get('users');
    if (snapshot.hasData) {
      final list = List<Map<String, dynamic>>.from(
        snapshot.requireData,
      ).map<User>(User.fromJson);
      UserService._cache.addAll({for (var item in list) item.id!: item});
      return Snapshot.withData(list);
    }
    return Snapshot.withError(snapshot.error);
  }

  Future<Snapshot<User>> getUserById({required int userId}) async {
    if (UserService._cache.containsKey(userId)) {
      return Snapshot.withData(UserService._cache[userId]!);
    }
    final snapshot = await get('users/$userId');
    if (snapshot.hasData) {
      final user = User.fromJson(snapshot.requireData);
      UserService._cache.update(userId, (_) => user, ifAbsent: () => user);
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
