import 'package:flutter/foundation.dart';
import 'package:server/models/user.dart';
import 'package:server/utils/snapshot.dart';
import 'package:tendon_loader/api/api_client.dart';
import 'package:tendon_loader/api/local_cache.dart';

@immutable
class UserService {
  factory UserService({ApiClient? client, LocalCache? cache}) =>
      client != null || cache != null
      ? UserService._(client ?? ApiClient(), cache ?? LocalCache.instance)
      : instance;

  const UserService._(this._client, this._cache);

  static final _instance = UserService._(ApiClient(), LocalCache.instance);
  static UserService get instance => _instance;

  final ApiClient _client;
  final LocalCache _cache;

  Future<Snapshot<Iterable<User>>> getAllUsers() async {
    if (_cache.users.isNotEmpty) return .data(_cache.users.values);
    final snapshot = await _client.get('users', fromJson: UserData.fromJson);
    if (snapshot.data case UserData userData) {
      _cache.users.addAll({for (var item in userData.users) item.id!: item});
      return .data(userData.users);
    }
    return .error(snapshot.error);
  }

  Future<Snapshot<User>> getUserById(int userId) async {
    if (_cache.users.containsKey(userId)) return .data(_cache.users[userId]!);
    final snapshot = await _client.get(
      'users/$userId',
      fromJson: User.fromJson,
    );
    if (snapshot.data case User user) {
      _cache.users.update(userId, (_) => user, ifAbsent: () => user);
      return .data(user);
    }
    return .error(snapshot.error);
  }

  Future<Snapshot<User>> authenticate(User user) async {
    if (user.username.isEmpty || user.password.isEmpty) {
      return const .error('Credentials cannot be empty.');
    }
    final snapshot = await _client.post(
      'users/auth',
      body: user.map,
      fromJson: User.fromJson,
    );
    if (snapshot.data case User user) {
      return .data(user);
    }
    return .error(snapshot.error);
  }
}
