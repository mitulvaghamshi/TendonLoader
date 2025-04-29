import 'dart:io';

import 'package:sqlite3/sqlite3.dart';

const _sqlPathKey = 'SETTINGS_SQL_PATH';

class SettingsStatements {
  SettingsStatements({required this.sqlPath});

  factory SettingsStatements.fromEnv() {
    const sqlPath = String.fromEnvironment(_sqlPathKey);
    assert(sqlPath.isNotEmpty, '[$_sqlPathKey]: Cannot be empty.');

    return SettingsStatements(sqlPath: sqlPath);
  }

  final String sqlPath;
  final List<PreparedStatement> stmts = [];
}

extension Utils on SettingsStatements {
  Future<void> prepare(Database database) async {
    if (stmts.isNotEmpty) return;
    final file = File.fromUri(Uri.file(sqlPath));
    final content = await file.readAsString();
    stmts.addAll(database.prepareMultiple(content));
  }
}
