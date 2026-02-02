import 'package:api_server/src/service/user_service.dart';

mixin TableUser on UserService {
  static const table = 'User';

  static const id = 'id';
  static const role = 'role';
  static const username = 'username';
  static const password = 'password';

  // ignore: unused_element
  static const sqlCreateTable =
      '''
CREATE TABLE IF NOT EXISTS "$table" (
    "$id"       INTEGER NOT NULL
                CONSTRAINT "PK_$table"
                PRIMARY KEY AUTOINCREMENT,
    "$username" TEXT    NOT NULL,
    "$password" TEXT    NOT NULL,
    "$role"     TEXT    DEFAULT 'user'
);
''';

  static const sqlSelectAll =
      '''
SELECT
      "$id",
      "$username",
      "$password",
      "$role"
FROM  "$table";
''';

  static const sqlSelectById =
      '''
SELECT
      "$id",
      "$username",
      "$password",
      "$role"
FROM  "$table"
WHERE "$id" = ?;
''';

  static const sqlSearch =
      '''
SELECT
      "$id",
      "$username",
      "$password",
      "$role"
FROM  "$table"
WHERE "$username" LIKE '%' || ? || '%';
''';

  static const sqlInsert =
      '''
INSERT INTO "$table" (
    "$username",
    "$password",
    "$role"
) VALUES (?, ?, ?);
''';

  static const sqlUpdate =
      '''
UPDATE "$table"
SET    "$username" = ?,
       "$password" = ?,
       "$role"     = ?
WHERE  "$id"       = ?;
''';

  static const sqlDelete =
      '''
DELETE
FROM  "$table"
WHERE "$id" = ?;
''';

  static const sqlAuth =
      '''
SELECT
      "$id",
      "$username",
      "$password",
      "$role"
FROM  "$table"
WHERE "$username" = ?
AND   "$password" = ?;
''';
}
