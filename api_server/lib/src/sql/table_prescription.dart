import 'package:api_server/src/service/prescription_service.dart';

mixin TablePrescription on PrescriptionService {
  static const table = 'Prescription';

  static const id = 'id';
  static const reps = 'reps';
  static const sets = 'sets';
  static const setRest = 'set_rest';
  static const holdTime = 'hold_time';
  static const restTime = 'rest_time';
  static const mvcDuration = 'mvc_duration';
  static const targetLoad = 'target_load';

  // ignore: unused_element
  static const sqlCreateTable =
      '''
CREATE TABLE IF NOT EXISTS "$table" (
    "$id"           INTEGER NOT NULL
                    CONSTRAINT "PK_$table"
                    PRIMARY KEY AUTOINCREMENT,
    "$reps"         INTEGER NOT NULL,
    "$sets"         INTEGER NOT NULL,
    "$setRest"      INTEGER NOT NULL,
    "$holdTime"     INTEGER NOT NULL,
    "$restTime"     INTEGER NOT NULL,
    "$mvcDuration"  INTEGER NOT NULL,
    "$targetLoad"   REAL    NOT NULL
);
''';

  static const sqlSelectAll =
      '''
SELECT
     "$id",
     "$reps",
     "$sets",
     "$setRest",
     "$holdTime",
     "$restTime",
     "$mvcDuration",
     "$targetLoad"
FROM "$table";
''';

  static const sqlSelectById =
      '''
SELECT
      "$id",
      "$reps",
      "$sets",
      "$setRest",
      "$holdTime",
      "$restTime",
      "$mvcDuration",
      "$targetLoad"
FROM  "$table"
WHERE "$id" = ?;
''';

  static const sqlSearch =
      '''
SELECT
      "$id",
      "$reps",
      "$sets",
      "$setRest",
      "$holdTime",
      "$restTime",
      "$mvcDuration",
      "$targetLoad"
FROM  "$table"
WHERE "$id" LIKE "%" || ? || "%";
''';

  static const sqlInsert =
      '''
INSERT INTO "$table" (
    "$reps",
    "$sets",
    "$setRest",
    "$holdTime",
    "$restTime",
    "$mvcDuration",
    "$targetLoad"
) VALUES (?, ?, ?, ?, ?, ?, ?);
''';

  static const sqlUpdate =
      '''
UPDATE "$table"
SET    "$reps"        = ?,
       "$sets"        = ?,
       "$setRest"     = ?,
       "$holdTime"    = ?,
       "$restTime"    = ?,
       "$mvcDuration" = ?,
       "$targetLoad"  = ?
WHERE  "$id"          = ?;
''';

  static const sqlDelete =
      '''
DELETE
FROM  "$table"
WHERE "$id" = ?;
''';
}
