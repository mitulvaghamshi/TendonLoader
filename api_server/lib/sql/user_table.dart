mixin UserTable {
  static const kTable = 'User';

  static const kId = 'id';
  static const kRole = 'role';
  static const kToken = 'token';
  static const kUsername = 'username';
  static const kPassword = 'password';

  static const schema = {
    'type': 'object',
    'required': [kUsername, kPassword],
    'properties': {
      kId: {'type': 'integer', 'format': 'Int64?'},
      kUsername: {'type': 'string'},
      kPassword: {'type': 'string'},
      kToken: {'type': 'string', 'format': 'String?'},
      kRole: {
        'type': 'string',
        'default': 'user',
        'enum': ['dev', 'user', 'admin'],
      },
    },
  };

  static const getResponses = {
    '200': {
      'description': 'OK',
      'content': {
        'application/json': {
          'schema': {r'$ref': '#/components/schemas/$kTable'},
        },
      },
    },
    '400': {r'$ref': '#/components/responses/BadRequest'},
    '401': {r'$ref': '#/components/responses/Unauthorized'},
    '403': {r'$ref': '#/components/responses/Forbidden'},
    '404': {r'$ref': '#/components/responses/NotFound'},
    '5XX': {r'$ref': '#/components/responses/ServerError'},
  };

  static const postResponses = {
    '201': {
      'description': '$kTable created successfully!',
      'content': {
        'application/json': {
          'schema': {r'$ref': '#/components/schemas/$kTable'},
        },
      },
    },
    '400': {r'$ref': '#/components/responses/BadRequest'},
  };

  static const requestBody = {
    'required': true,
    'content': {
      'application/json': {
        'schema': {r'$ref': '#/components/schemas/$kTable'},
      },
    },
  };

  static const sqlCreateTable =
      '''
CREATE TABLE IF NOT EXISTS "$kTable" (
    "$kId"       INTEGER NOT NULL
                 CONSTRAINT "PK_$kTable"
                 PRIMARY KEY AUTOINCREMENT,
    "$kUsername" TEXT    NOT NULL,
    "$kPassword" TEXT    NOT NULL,
    "$kRole"     TEXT    DEFAULT 'user'
);
''';

  static const sqlSelectAll =
      '''
SELECT
      "$kId",
      "$kUsername",
      "$kPassword",
      "$kRole"
FROM  "$kTable";
''';

  static const sqlSelectById =
      '''
SELECT
      "$kId",
      "$kUsername",
      "$kPassword",
      "$kRole"
FROM  "$kTable"
WHERE "$kId" = ?;
''';

  static const sqlSearch =
      '''
SELECT
      "$kId",
      "$kUsername",
      "$kPassword",
      "$kRole"
FROM  "$kTable"
WHERE "$kUsername" LIKE '%' || ? || '%';
''';

  static const sqlInsert =
      '''
INSERT INTO "$kTable" (
    "$kUsername",
    "$kPassword",
    "$kRole"
) VALUES (?, ?, ?);
''';

  static const sqlUpdate =
      '''
UPDATE "$kTable"
SET    "$kUsername" = ?,
       "$kPassword" = ?,
       "$kRole"     = ?
WHERE  "$kId"       = ?;
''';

  static const sqlDelete =
      '''
DELETE
FROM  "$kTable"
WHERE "$kId" = ?;
''';

  static const sqlAuth =
      '''
SELECT
      "$kId",
      "$kUsername",
      "$kPassword",
      "$kRole"
FROM  "$kTable"
WHERE "$kUsername" = ?
AND   "$kPassword" = ?;
''';
}
