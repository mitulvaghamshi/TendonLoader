import 'package:flutter/foundation.dart';

@immutable
class UserData {
  const UserData._({required this.users});

  const UserData.empty() : users = const [];

  factory UserData.fromJson(Object? data) {
    if (data case {'users': List<dynamic> users}) {
      final items = List<Map<String, dynamic>>.from(users);
      return UserData._(users: items.map(User.fromJson));
    }
    throw FormatException('[UserData]: Invalid JSON data $data');
  }

  final Iterable<User> users;
}

@immutable
class User {
  const User._({
    required this.id,
    required this.username,
    required this.password,
    required this.token,
  });

  const User.empty() : id = null, username = '', password = '', token = null;

  const User.from({required this.username, required this.password})
    : id = null,
      token = null;

  factory User.fromJson(Object? json) {
    if (json case {
      'id': int id,
      'username': String username,
      'password': String password,
      // 'token': int token,
    }) {
      return User._(
        id: id,
        username: username,
        password: password,
        token: null,
      );
    }
    throw const FormatException('[User]: Invalid JSON data.');
  }

  final int? id;
  final int? token;
  final String password;
  final String username;
}

extension Utils on User {
  String get name => username
      .split('@')
      .first
      .replaceFirst(RegExp(r'\w'), username[0].toUpperCase());

  Map<String, dynamic> get map => {
    'id': id,
    'username': username,
    'password': password,
  };

  User copyWith({int? id, String? username, String? password, int? token}) =>
      User._(
        id: id ?? this.id,
        username: username ?? this.username,
        password: password ?? this.password,
        token: token ?? this.token,
      );
}

extension Export on User {
  Future<void> download() async {
    throw UnimplementedError('Download not implemented.');
    // final Export query = exportRef!;
    // final Iterable<ArchiveFile> iterable =
    //     query.docs.map<ArchiveFile>((e) => e.toExcelSheet());
    // final Archive archive = Archive();
    // iterable.forEach(archive.addFile);
    // await saveExcel(name: '$id.zip', bytes: ZipEncoder().encode(archive));
  }

  Future<void> delete() async {
    throw UnimplementedError('Delete not implemented.');
    // final Export query = exportRef!;
    // query.docs.map((e) => e.reference.delete());
    // await reference!.delete();
  }
}
