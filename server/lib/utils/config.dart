import 'dart:io' show File;

import 'package:server/utils/app_router.dart' as v1;
import 'package:shelf/shelf.dart';
import 'package:sqlite3/sqlite3.dart';

class Config {
  const Config({required this.database});

  factory Config.create() {
    const dbPath = String.fromEnvironment(_dbFilePathKey);
    assert(dbPath.isNotEmpty, 'dbpath is empty');
    return Config(database: sqlite3.open(dbPath));
  }

  final Database database;
}

extension Utils on Config {
  Future<Response> Function(Request) get handler => v1.appRouter.call;

  Future<void> init() async {
    userStmt.addAll(await _prepare(_userSqlPathKey));
    settingsStmt.addAll(await _prepare(_settingsSqlPathKey));
    exerciseStmt.addAll(await _prepare(_exersiceSqlPathKey));
    prescriptionStmt.addAll(await _prepare(_prescriptionSqlPathKey));
  }

  Future<Iterable<PreparedStatement>> _prepare(String key) async {
    final sqlPath = String.fromEnvironment(key);
    assert(sqlPath.isNotEmpty, '$key is missing');
    final content = await File.fromUri(Uri.file(sqlPath)).readAsString();
    return database.prepareMultiple(content);
  }
}

const _dbFilePathKey = 'DB_PATH';
const _userSqlPathKey = 'USER_SQL_PATH';
const _settingsSqlPathKey = 'SETTINGS_SQL_PATH';
const _exersiceSqlPathKey = 'EXERCISE_SQL_PATH';
const _prescriptionSqlPathKey = 'PRESCRIPTION_SQL_PATH';

final List<PreparedStatement> userStmt = [];
final List<PreparedStatement> settingsStmt = [];
final List<PreparedStatement> prescriptionStmt = [];
final List<PreparedStatement> exerciseStmt = [];
