mixin ExerciseTable {
  static const kTable = 'Exercise';

  static const kId = 'id';
  static const kUserId = 'user_id';
  static const kPrescriptionId = 'prescription_id';
  static const kPainScore = 'pain_score';
  static const kDatetime = 'datetime';
  static const kTolerable = 'tolerable';
  static const kCompleted = 'completed';
  static const kProgressorId = 'progressor_id';
  static const kMvcValue = 'mvc_value';
  static const kData = 'data';

  static const schema = {
    'type': 'object',
    'required': [
      kId,
      kUserId,
      kPainScore,
      kDatetime,
      kTolerable,
      kCompleted,
      kProgressorId,
      kData,
    ],
    'properties': {
      kId: {'type': 'integer', 'format': 'Int64'},
      kUserId: {'type': 'integer', 'format': 'Int64'},
      kPrescriptionId: {'type': 'integer', 'format': 'Int64?'},
      kPainScore: {'type': 'number', 'format': 'Double'},
      kDatetime: {'type': 'string'},
      kTolerable: {'type': 'string'},
      kCompleted: {'type': 'boolean', 'format': 'Boolean'},
      kProgressorId: {'type': 'string'},
      kMvcValue: {'type': 'number', 'format': 'Double?'},
      kData: {
        'type': 'array',
        'format': 'List<ChartData>',
        'items': {r'$ref': '#/components/schemas/ChartData'},
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

  // ignore: unused_element
  static const sqlCreateTable =
      '''
CREATE TABLE IF NOT EXISTS "$kTable" (
    "$kId"             INTEGER NOT NULL
                       CONSTRAINT "PK_$kTable"
                       PRIMARY KEY AUTOINCREMENT,
    "$kCompleted"      INTEGER NOT NULL,
    "$kData"           TEXT    NOT NULL,
    "$kDatetime"       TEXT    NOT NULL,
    "$kMvcValue"       REAL        NULL,
    "$kPainScore"      REAL    NOT NULL,
    "$kPrescriptionId" INTEGER     NULL,
    "$kProgressorId"   TEXT    NOT NULL,
    "$kTolerable"      TEXT    NOT NULL,
    "$kUserId"         INTEGER NOT NULL
);
''';

  static const sqlSelectAll =
      '''
SELECT
     "$kId",
     "$kCompleted",
     "$kData",
     "$kDatetime",
     "$kMvcValue",
     "$kPainScore",
     "$kPrescriptionId",
     "$kProgressorId",
     "$kTolerable",
     "$kUserId"
FROM "$kTable";
''';

  static const sqlSelectById =
      '''
SELECT
      "$kId",
      "$kCompleted",
      "$kData",
      "$kDatetime",
      "$kMvcValue",
      "$kPainScore",
      "$kPrescriptionId",
      "$kProgressorId",
      "$kTolerable",
      "$kUserId"
FROM  "$kTable"
WHERE "$kId" = ?;
''';

  static const sqlSearch =
      '''
SELECT
       "$kId",
       "$kCompleted",
       "$kData",
       "$kDatetime",
       "$kMvcValue",
       "$kPainScore",
       "$kPrescriptionId",
       "$kProgressorId",
       "$kTolerable",
       "$kUserId"
FROM   "$kTable"
WHERE  "$kId"             LIKE '%' || ? || '%'
OR     "$kUserId"         LIKE '%' || ? || '%'
OR     "$kPrescriptionId" LIKE '%' || ? || '%'
OR     "$kDatetime"       LIKE '%' || ? || '%';
''';

  static const sqlInsert =
      '''
INSERT INTO "$kTable" (
    "$kCompleted",
    "$kData",
    "$kDatetime",
    "$kMvcValue",
    "$kPainScore",
    "$kPrescriptionId",
    "$kProgressorId",
    "$kTolerable",
    "$kUserId"
) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);
''';

  static const sqlUpdate =
      '''
UPDATE "$kTable"
SET    "$kCompleted"      = ?,
       "$kData"           = ?,
       "$kDatetime"       = ?,
       "$kMvcValue"       = ?,
       "$kPainScore"      = ?,
       "$kPrescriptionId" = ?,
       "$kProgressorId"   = ?,
       "$kTolerable"      = ?,
       "$kUserId"         = ?
WHERE  "$kId"             = ?;
''';

  static const sqlDelete =
      '''
DELETE
FROM  "$kTable"
WHERE "$kId" = ?;
''';
}
