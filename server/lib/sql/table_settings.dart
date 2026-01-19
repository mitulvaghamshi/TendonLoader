import 'package:server/services/settings_service.dart';

mixin TableSettings on SettingsService {
  static const table = 'Settings';

  static const id = 'id';
  static const autoUpload = 'auto_upload';
  static const darkMode = 'dark_mode';
  static const editablePrescription = 'editable_prescription';
  static const graphScale = 'graph_scale';
  static const prescriptionId = 'prescription_id';
  static const userId = 'user_id';

  // ignore: unused_element
  static const sqlCreateTable =
      '''
CREATE TABLE IF NOT EXISTS "$table" (
    "$id"                   INTEGER NOT NULL
                            CONSTRAINT "PK_$table"
                            PRIMARY KEY AUTOINCREMENT,
    "$autoUpload"           INTEGER NOT NULL,
    "$darkMode"             INTEGER NOT NULL,
    "$editablePrescription" INTEGER NOT NULL,
    "$graphScale"           REAL    NOT NULL,
    "$prescriptionId"       INTEGER     NULL,
    "$userId"               INTEGER NOT NULL
);
''';

  static const sqlSelectAll =
      '''
SELECT
     "$id",
     "$autoUpload",
     "$darkMode",
     "$editablePrescription",
     "$graphScale",
     "$prescriptionId",
     "$userId"
FROM "$table";
''';

  static const sqlSelectById =
      '''
SELECT
      "$id",
      "$autoUpload",
      "$darkMode",
      "$editablePrescription",
      "$graphScale",
      "$prescriptionId",
      "$userId"
FROM  "$table"
WHERE "$id" = ?;
''';

  static const sqlSearch =
      '''
SELECT
      "$id",
      "$autoUpload",
      "$darkMode",
      "$editablePrescription",
      "$graphScale",
      "$prescriptionId",
      "$userId"
FROM  "$table"
WHERE "$userId" = ?;
''';

  static const sqlInsert =
      '''
INSERT INTO "$table" (
    "$autoUpload",
    "$darkMode",
    "$editablePrescription",
    "$graphScale",
    "$prescriptionId",
    "$userId"
)
VALUES (?, ?, ?, ?, ?, ?);
''';

  static const sqlUpdate =
      '''
UPDATE "$table"
SET    "$autoUpload"           = ?,
       "$darkMode"             = ?,
       "$editablePrescription" = ?,
       "$graphScale"           = ?,
       "$prescriptionId"       = ?,
       "$userId"               = ?
WHERE  "$id"                   = ?;
''';

  static const sqlDelete =
      '''
DELETE FROM "$table"
WHERE "$id" = ?;
''';
}
