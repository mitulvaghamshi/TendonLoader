mixin PrescriptionTable {
  static const kTable = 'Prescription';

  static const kId = 'id';
  static const kReps = 'reps';
  static const kSets = 'sets';
  static const kSetRest = 'set_rest';
  static const kHoldTime = 'hold_time';
  static const kRestTime = 'rest_time';
  static const kMvcDuration = 'mvc_duration';
  static const kTargetLoad = 'target_load';

  static const schema = {
    'type': 'object',
    'required': [
      kReps,
      kSets,
      kSetRest,
      kHoldTime,
      kRestTime,
      kMvcDuration,
      kTargetLoad,
    ],
    'properties': {
      kId: {'type': 'integer', 'format': 'Int64?'},
      kReps: {'type': 'integer', 'format': 'Int64'},
      kSets: {'type': 'integer', 'format': 'Int64'},
      kSetRest: {'type': 'integer', 'format': 'Int64'},
      kHoldTime: {'type': 'integer', 'format': 'Int64'},
      kRestTime: {'type': 'integer', 'format': 'Int64'},
      kMvcDuration: {'type': 'integer', 'format': 'Int64'},
      kTargetLoad: {'type': 'number', 'format': 'Double'},
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

  // ignore: unused_element
  static const sqlCreateTable =
      '''
CREATE TABLE IF NOT EXISTS "$kTable" (
    "$kId"           INTEGER NOT NULL
                    CONSTRAINT "PK_$kTable"
                    PRIMARY KEY AUTOINCREMENT,
    "$kReps"         INTEGER NOT NULL,
    "$kSets"         INTEGER NOT NULL,
    "$kSetRest"      INTEGER NOT NULL,
    "$kHoldTime"     INTEGER NOT NULL,
    "$kRestTime"     INTEGER NOT NULL,
    "$kMvcDuration"  INTEGER NOT NULL,
    "$kTargetLoad"   REAL    NOT NULL
);
''';

  static const sqlSelectAll =
      '''
SELECT
     "$kId",
     "$kReps",
     "$kSets",
     "$kSetRest",
     "$kHoldTime",
     "$kRestTime",
     "$kMvcDuration",
     "$kTargetLoad"
FROM "$kTable";
''';

  static const sqlSelectById =
      '''
SELECT
      "$kId",
      "$kReps",
      "$kSets",
      "$kSetRest",
      "$kHoldTime",
      "$kRestTime",
      "$kMvcDuration",
      "$kTargetLoad"
FROM  "$kTable"
WHERE "$kId" = ?;
''';

  static const sqlSearch =
      '''
SELECT
      "$kId",
      "$kReps",
      "$kSets",
      "$kSetRest",
      "$kHoldTime",
      "$kRestTime",
      "$kMvcDuration",
      "$kTargetLoad"
FROM  "$kTable"
WHERE "$kId" LIKE "%" || ? || "%";
''';

  static const sqlInsert =
      '''
INSERT INTO "$kTable" (
    "$kReps",
    "$kSets",
    "$kSetRest",
    "$kHoldTime",
    "$kRestTime",
    "$kMvcDuration",
    "$kTargetLoad"
) VALUES (?, ?, ?, ?, ?, ?, ?);
''';

  static const sqlUpdate =
      '''
UPDATE "$kTable"
SET    "$kReps"        = ?,
       "$kSets"        = ?,
       "$kSetRest"     = ?,
       "$kHoldTime"    = ?,
       "$kRestTime"    = ?,
       "$kMvcDuration" = ?,
       "$kTargetLoad"  = ?
WHERE  "$kId"          = ?;
''';

  static const sqlDelete =
      '''
DELETE
FROM  "$kTable"
WHERE "$kId" = ?;
''';
}
