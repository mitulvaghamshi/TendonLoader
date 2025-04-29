import 'dart:io';

import 'package:sqlite3/sqlite3.dart';

const _sqlPathKey = 'USER_SQL_PATH';

class UserStatements {
  UserStatements({required this.sqlPath});

  factory UserStatements.fromEnv() {
    const sqlPath = String.fromEnvironment(_sqlPathKey);
    assert(sqlPath.isNotEmpty, '[$_sqlPathKey]: Cannot be empty.');

    return UserStatements(sqlPath: sqlPath);
  }

  final String sqlPath;
  final List<PreparedStatement> stmts = [];
}

extension Utils on UserStatements {
  Future<void> prepare(Database database) async {
    if (stmts.isNotEmpty) return;
    final file = File.fromUri(Uri.file(sqlPath));
    final content = await file.readAsString();
    stmts.addAll(database.prepareMultiple(content));
  }
}
