import 'package:flutter/foundation.dart';

@immutable
final class User {
  const User._({
    required this.id,
    required this.username,
    required this.password,
  });

  const User.empty()
      : id = null,
        username = '',
        password = '';

  factory User.fromJson(final map) => ExUser._parseJson(map);

  final int? id;
  final String username;
  final String password;
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

  User copyWith({
    final int? id,
    final String? username,
    final String? password,
  }) {
    return User._(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  static User _parseJson(final map) {
    if (map
        case {
          'id': final int id,
          'username': final String username,
          'password': final String password,
        }) {
      return User._(
        id: id,
        username: username,
        password: password,
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
