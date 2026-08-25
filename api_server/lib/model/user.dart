import 'package:api_server/sql/user_table.dart';

class const UserData._({required final Iterable<User> users}) {
  factory empty() => const ._(users: []);

  factory fromJson(Object? json) {
    if (json case {'users': final List<dynamic> items}) {
      return ._(users: items.map(User.fromJson));
    }
    throw Exception('[$UserData]: ${StackTrace.current}');
  }
}

class const User._({
  required final int? id,
  required final String username,
  required final String password,
  required final String? token,
  required final String role,
}) {
  factory empty() {
    return const ._(
      id: null,
      username: '',
      password: '',
      token: null,
      role: 'user',
    );
  }

  factory fromJson(Object? json) {
    if (json case {
      UserTable.kId: final int? id,
      UserTable.kUsername: final String username,
      UserTable.kPassword: final String password,
      UserTable.kToken: final String? token,
      UserTable.kRole: final String? role,
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
      UserTable.kId: final int? id,
      UserTable.kUsername: final String username,
      UserTable.kPassword: final String password,
      UserTable.kToken: final String? token,
    }) {
      return ._(
        id: id,
        username: username,
        password: password,
        token: token,
        role: 'user',
      );
    }

    throw Exception('[$User]: ${StackTrace.current}');
  }
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
