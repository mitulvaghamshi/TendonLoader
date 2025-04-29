import 'dart:io';

import 'package:sqlite3/sqlite3.dart';

const _sqlPathKey = 'EXERCISE_SQL_PATH';

class ExerciseStatements {
  ExerciseStatements({required this.sqlPath});

  factory ExerciseStatements.fromEnv() {
    const sqlPath = String.fromEnvironment(_sqlPathKey);
    assert(sqlPath.isNotEmpty, '[$_sqlPathKey]: Cannot be empty.');

    return ExerciseStatements(sqlPath: sqlPath);
  }

  final String sqlPath;
  final List<PreparedStatement> stmts = [];
}

extension Utils on ExerciseStatements {
  Future<void> prepare(Database database) async {
    if (stmts.isNotEmpty) return;
    final file = File.fromUri(Uri.file(sqlPath));
    final content = await file.readAsString();
    stmts.addAll(database.prepareMultiple(content));
  }
}
