import 'dart:io';

import 'package:sqlite3/sqlite3.dart';

const _sqlPathKey = 'PRESCRIPTION_SQL_PATH';

class PrescriptionStatements {
  PrescriptionStatements({required this.sqlPath});

  factory PrescriptionStatements.fromEnv() {
    const sqlPath = String.fromEnvironment(_sqlPathKey);
    assert(sqlPath.isNotEmpty, '[$_sqlPathKey]: Cannot be empty.');

    return PrescriptionStatements(sqlPath: sqlPath);
  }

  final String sqlPath;
  final List<PreparedStatement> stmts = [];
}

extension Utils on PrescriptionStatements {
  Future<void> prepare(Database database) async {
    if (stmts.isNotEmpty) return;
    final file = File.fromUri(Uri.file(sqlPath));
    final content = await file.readAsString();
    stmts.addAll(database.prepareMultiple(content));
  }
}
