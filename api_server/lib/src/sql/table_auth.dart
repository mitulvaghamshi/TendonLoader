mixin TableAuth {
  static const table = 'Auth';

  static const id = 'id';
  static const userId = 'user_id';
  static const token = 'token';
  static const lastActive = 'last_active';

  // ignore: unused_element
  static const sqlCreateTable =
      '''
CREATE TABLE IF NOT EXISTS "$table" (
    "$id"             INTEGER NOT NULL
                      CONSTRAINT "PK_$table"
                      PRIMARY KEY AUTOINCREMENT,
    "$userId"         INTEGER NOT NULL,
    "$token"          TEXT    NOT NULL,
    "$lastActive"     TEXT    NOT NULL
);
''';

  static const sqlInsert =
      '''
INSERT INTO "$table" (
    "$userId",
    "$token",
    "$lastActive"
) VALUES (?, ?, ?);
''';

  static const sqlDelete =
      '''
DELETE FROM "$table"
WHERE "$token" = ?;
''';

  static const sqlSelectByToken =
      '''
SELECT
      "$userId",
      "$token",
      "$lastActive"
FROM  "$table"
WHERE "$token" = ?;
''';
}
