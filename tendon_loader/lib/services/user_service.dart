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
      return .data(UserService._cache.values);
    }
    final snapshot = await get('users');
    if (snapshot.hasData) {
      final items = List<Map<String, dynamic>>.from(snapshot.requireData);
      final users = items.map<User>(User.fromJson);
      UserService._cache.addAll({for (var item in users) item.id!: item});
      return .data(users);
    }
    return .error(snapshot.error);
  }

  Future<Snapshot<User>> getUserById(int userId) async {
    if (UserService._cache.containsKey(userId)) {
      return .data(UserService._cache[userId]!);
    }
    final snapshot = await get('users/$userId');
    if (snapshot.hasData) {
      final user = User.fromJson(snapshot.requireData);
      UserService._cache.update(userId, (_) => user, ifAbsent: () => user);
      return .data(user);
    }
    return .error(snapshot.error);
  }

  Future<Snapshot<User>> authenticate(User user) async {
    if (user.username.isEmpty || user.password.isEmpty) {
      return const .error('Credentials cannot be empty.');
    }
    final values = base64.encode(
      utf8.encode('${user.username}:${user.password}'),
    );
    final snapshot = await post('users/auth', values: {'credential': values});
    if (snapshot.data case {'id': int userId, 'token': int token}) {
      return .data(user.copyWith(id: userId, token: token));
    }
    return .error(snapshot.error);
  }
}
