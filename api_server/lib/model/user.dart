import 'package:api_server/sql/user_table.dart';

class UserData {
  const UserData._({required this.users});

  const UserData.empty() : users = const [];

  factory UserData.fromJson(Object? json) {
    if (json case {'users': List<dynamic> items}) {
      return ._(users: items.map(User.fromJson));
    }

    throw FormatException('[$UserData]: Invalid JSON data: $json');
  }

  final Iterable<User> users;
}

class User {
  const User._({
    required this.id,
    required this.username,
    required this.password,
    required this.token,
    required this.role,
  });

  const User.empty()
    : id = null,
      username = '',
      password = '',
      token = null,
      role = 'user';

  factory User.fromJson(Object? json) {
    if (json case {
      UserTable.kId: int? id,
      UserTable.kUsername: String username,
      UserTable.kPassword: String password,
      UserTable.kToken: String? token,
      UserTable.kRole: String? role,
    }) {
      return ._(
        id: id,
        username: username,
        password: password,
        token: token,
        role: role ?? 'user',
      );
    }
    // Fallback for missing role in older JSON or other structures if necessary,
    // but the pattern matching above handles the structural check.
    // If exact match is required for the pattern,
    // we might need to be more flexible. Let's assume standard structure.
    if (json case {
      UserTable.kId: int? id,
      UserTable.kUsername: String username,
      UserTable.kPassword: String password,
      UserTable.kToken: String? token,
    }) {
      return ._(
        id: id,
        username: username,
        password: password,
        token: token,
        role: 'user',
      );
    }

    throw FormatException('[$User]: Invalid JSON data: $json');
  }

  final int? id;
  final String? token;
  final String role;
  final String password;
  final String username;
}

extension UserExt on User {
  String get name => username
      .split('@')
      .first
      .replaceFirst(RegExp(r'\w'), username[0].toUpperCase());

  Map<String, dynamic> get map => {
    UserTable.kId: id,
    UserTable.kUsername: username,
    UserTable.kPassword: password,
    UserTable.kToken: token,
    UserTable.kRole: role,
  };

  User copyWith({
    int? id,
    String? username,
    String? password,
    String? token,
    String? role,
  }) => ._(
    id: id ?? this.id,
    username: username ?? this.username,
    password: password ?? this.password,
    token: token ?? this.token,
    role: role ?? this.role,
  );
}
