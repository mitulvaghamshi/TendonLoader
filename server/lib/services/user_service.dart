import 'package:sqlite3/sqlite3.dart';

class UserService {
  const UserService(this.db);

  final Database db;

  ResultSet auth({required String username, required String password}) =>
      db.select(_auth, [username, password]);

  ResultSet selectAll() => db.select(_selectAll);

  ResultSet selectBy(int id) => db.select(_selectById, [id]);

  ResultSet search(String term) => db.select(_search, [term]);

  ResultSet insert({required String username, required String password}) =>
      db.select(_insert, [username, password]);

  ResultSet update({
    required int id,
    required String username,
    required String password,
  }) => db.select(_update, [username, password, id]);

  ResultSet delete(int? id) => db.select(_delete, [id]);
}

// ignore: unused_element
const _createTable = '''
CREATE TABLE IF NOT EXISTS "User" (
    "id"       INTEGER NOT NULL CONSTRAINT "PK_User" PRIMARY KEY AUTOINCREMENT,
    "username" TEXT    NOT NULL,
    "password" TEXT    NOT NULL
);
''';

const _selectAll = '''
SELECT
    "id",
    "username",
    "password"
FROM "User";
''';

const _selectById = '''
SELECT
    "id",
    "username",
    "password"
FROM "User"
WHERE "id" = ?;
''';

const _search = '''
SELECT
    "id",
    "username",
    "password"
FROM   "User"
WHERE  "username" LIKE '%' || ? || '%';
''';

const _insert = '''
INSERT INTO "User" (
    "username",
    "password"
) VALUES (?, ?);
''';

const _update = '''
UPDATE "User"
SET    "username" = ?,
       "password" = ?
WHERE  "id"       = ?;
''';

const _delete = '''
DELETE FROM "User"
WHERE "id" = ?;
''';

const _auth = '''
SELECT
    "id",
    "username",
    "password"
FROM   "User"
WHERE  "username" = ?
AND    "password" = ?;
''';
