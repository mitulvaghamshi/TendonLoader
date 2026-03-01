mixin SettingsTable {
  static const kTable = 'Settings';

  static const kId = 'id';
  static const kAutoUpload = 'auto_upload';
  static const kDarkMode = 'dark_mode';
  static const kEditablePrescription = 'editable_prescription';
  static const kGraphScale = 'graph_scale';
  static const kPrescriptionId = 'prescription_id';
  static const kUserId = 'user_id';

  static const schema = {
    'type': 'object',
    'required': [kDarkMode, kAutoUpload, kEditablePrescription, kGraphScale],
    'properties': {
      kId: {'type': 'integer', 'format': 'Int64?'},
      kUserId: {'type': 'integer', 'format': 'Int64?'},
      kPrescriptionId: {'type': 'integer', 'format': 'Int64?'},
      kDarkMode: {'type': 'boolean', 'format': 'Boolean'},
      kAutoUpload: {'type': 'boolean', 'format': 'Boolean'},
      kEditablePrescription: {'type': 'boolean', 'format': 'Boolean'},
      kGraphScale: {'type': 'number', 'format': 'Double'},
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
    "$kId"                   INTEGER NOT NULL
                            CONSTRAINT "PK_$kTable"
                            PRIMARY KEY AUTOINCREMENT,
    "$kAutoUpload"           INTEGER NOT NULL,
    "$kDarkMode"             INTEGER NOT NULL,
    "$kEditablePrescription" INTEGER NOT NULL,
    "$kGraphScale"           REAL    NOT NULL,
    "$kPrescriptionId"       INTEGER     NULL,
    "$kUserId"               INTEGER NOT NULL
);
''';

  static const sqlSelectAll =
      '''
SELECT
     "$kId",
     "$kAutoUpload",
     "$kDarkMode",
     "$kEditablePrescription",
     "$kGraphScale",
     "$kPrescriptionId",
     "$kUserId"
FROM "$kTable";
''';

  static const sqlSelectById =
      '''
SELECT
      "$kId",
      "$kAutoUpload",
      "$kDarkMode",
      "$kEditablePrescription",
      "$kGraphScale",
      "$kPrescriptionId",
      "$kUserId"
FROM  "$kTable"
WHERE "$kId" = ?;
''';

  static const sqlSearch =
      '''
SELECT
      "$kId",
      "$kAutoUpload",
      "$kDarkMode",
      "$kEditablePrescription",
      "$kGraphScale",
      "$kPrescriptionId",
      "$kUserId"
FROM  "$kTable"
WHERE "$kUserId" = ?;
''';

  static const sqlInsert =
      '''
INSERT INTO "$kTable" (
    "$kAutoUpload",
    "$kDarkMode",
    "$kEditablePrescription",
    "$kGraphScale",
    "$kPrescriptionId",
    "$kUserId"
) VALUES (?, ?, ?, ?, ?, ?);
''';

  static const sqlUpdate =
      '''
UPDATE "$kTable"
SET    "$kAutoUpload"           = ?,
       "$kDarkMode"             = ?,
       "$kEditablePrescription" = ?,
       "$kGraphScale"           = ?,
       "$kPrescriptionId"       = ?,
       "$kUserId"               = ?
WHERE  "$kId"                   = ?;
''';

  static const sqlDelete =
      '''
DELETE
FROM  "$kTable"
WHERE "$kId" = ?;
''';
}
