import 'package:flutter/foundation.dart';

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

  factory User.fromJson(Map<String, dynamic> map) => ExUser._parseJson(map);

  final int? id;
  final int? token;
  final String password;
  final String username;
}

extension ExUser on User {
  String get name => username
      .split('@')
      .first
      .replaceFirst(RegExp(r'\w'), username[0].toUpperCase());

  Map<String, dynamic> get json => {
    'id': id,
    'username': username,
    'password': password,
  };

  User copyWith({int? id, String? username, String? password, int? token}) {
    return User._(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
      token: token ?? this.token,
    );
  }

  static User _parseJson(Map<String, dynamic> map) {
    if (map case {
      'id': int id,
      'username': String username,
      'password': String password,
    }) {
      return User._(
        id: id,
        username: username,
        password: password,
        token: null,
      );
    }
    throw const FormatException('[User]: Invalid JSON');
  }

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
