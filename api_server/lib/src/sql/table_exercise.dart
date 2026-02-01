import 'package:api_server/src/services/exercise_service.dart';

mixin TableExercise on ExerciseService {
  static const table = 'Exercise';

  static const id = 'id';
  static const completed = 'completed';
  static const data = 'data';
  static const datetime = 'datetime';
  static const mvcValue = 'mvc_value';
  static const painScore = 'pain_score';
  static const prescriptionId = 'prescription_id';
  static const progressorId = 'progressor_id';
  static const tolerable = 'tolerable';
  static const userId = 'user_id';

  // ignore: unused_element
  static const sqlCreateTable =
      '''
CREATE TABLE IF NOT EXISTS "$table" (
    "$id"             INTEGER NOT NULL
                      CONSTRAINT "PK_$table"
                      PRIMARY KEY AUTOINCREMENT,
    "$completed"      INTEGER NOT NULL,
    "$data"           TEXT    NOT NULL,
    "$datetime"       TEXT    NOT NULL,
    "$mvcValue"       REAL        NULL,
    "$painScore"      REAL    NOT NULL,
    "$prescriptionId" INTEGER     NULL,
    "$progressorId"   TEXT    NOT NULL,
    "$tolerable"      TEXT    NOT NULL,
    "$userId"         INTEGER NOT NULL
);
''';

  static const sqlSelectAll =
      '''
SELECT
     "$id",
     "$completed",
     "$data",
     "$datetime",
     "$mvcValue",
     "$painScore",
     "$prescriptionId",
     "$progressorId",
     "$tolerable",
     "$userId"
FROM "$table";
''';

  static const sqlSelectById =
      '''
SELECT
      "$id",
      "$completed",
      "$data",
      "$datetime",
      "$mvcValue",
      "$painScore",
      "$prescriptionId",
      "$progressorId",
      "$tolerable",
      "$userId"
FROM  "$table"
WHERE "$id" = ?;
''';

  static const sqlSearch =
      '''
SELECT
       "$id",
       "$completed",
       "$data",
       "$datetime",
       "$mvcValue",
       "$painScore",
       "$prescriptionId",
       "$progressorId",
       "$tolerable",
       "$userId"
FROM   "$table"
WHERE  "$id"             LIKE '%' || ? || '%'
OR     "$userId"         LIKE '%' || ? || '%'
OR     "$prescriptionId" LIKE '%' || ? || '%'
OR     "$datetime"       LIKE '%' || ? || '%';
''';

  static const sqlInsert =
      '''
INSERT INTO "$table" (
    "$completed",
    "$data",
    "$datetime",
    "$mvcValue",
    "$painScore",
    "$prescriptionId",
    "$progressorId",
    "$tolerable",
    "$userId"
)
VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);
''';

  static const sqlUpdate =
      '''
UPDATE "$table"
SET    "$completed"      = ?,
       "$data"           = ?,
       "$datetime"       = ?,
       "$mvcValue"       = ?,
       "$painScore"      = ?,
       "$prescriptionId" = ?,
       "$progressorId"   = ?,
       "$tolerable"      = ?,
       "$userId"         = ?
WHERE  "$id"             = ?;
''';

  static const sqlDelete =
      '''
DELETE
FROM  "$table"
WHERE "$id" = ?;
''';
}
