import 'package:sqlite3/sqlite3.dart';

class ExerciseService {
  const ExerciseService(this.db);

  final Database db;

  ResultSet selectAll() => db.select(_selectAll);

  ResultSet selectBy(int id) => db.select(_selectById, [id]);

  ResultSet search(String term) => db.select(_search, [term, term, term, term]);

  ResultSet insert({
    required int userId,
    required double painScore,
    required String datetime,
    required String tolerable,
    required int completed,
    required String progressorId,
    required int? prescriptionId,
    required double? mvcValue,
    required String data,
  }) => db.select(_insert, [
    completed,
    data,
    datetime,
    mvcValue,
    painScore,
    prescriptionId,
    progressorId,
    tolerable,
    userId,
  ]);

  ResultSet update({
    required int id,
    required int userId,
    required double painScore,
    required String datetime,
    required String tolerable,
    required int completed,
    required String progressorId,
    required int? prescriptionId,
    required double? mvcValue,
    required String data,
  }) => db.select(_update, [
    completed,
    data,
    datetime,
    mvcValue,
    painScore,
    prescriptionId,
    progressorId,
    tolerable,
    userId,
    id,
  ]);

  ResultSet delete(int id) => db.select(_delete, [id]);
}

// ignore: unused_element
const _createTable = '''
CREATE TABLE IF NOT EXISTS "Exercise" (
    "id"              INTEGER NOT NULL CONSTRAINT "PK_Exercise" PRIMARY KEY AUTOINCREMENT,
    "completed"       INTEGER NOT NULL,
    "data"            TEXT    NOT NULL,
    "datetime"        TEXT    NOT NULL,
    "mvc_value"       REAL        NULL,
    "pain_score"      REAL    NOT NULL,
    "prescription_id" INTEGER     NULL,
    "progressor_id"   TEXT    NOT NULL,
    "tolerable"       TEXT    NOT NULL,
    "user_id"         INTEGER NOT NULL
);
''';

const _selectAll = '''
SELECT
    "id",
    "completed",
    "data",
    "datetime",
    "mvc_value",
    "pain_score",
    "prescription_id",
    "progressor_id",
    "tolerable",
    "user_id"
FROM "Exercise";
''';

const _selectById = '''
SELECT
    "id",
    "completed",
    "data",
    "datetime",
    "mvc_value",
    "pain_score",
    "prescription_id",
    "progressor_id",
    "tolerable",
    "user_id"
FROM "Exercise"
WHERE "id" = ?;
''';

const _search = '''
SELECT
    "id",
    "completed",
    "data",
    "datetime",
    "mvc_value",
    "pain_score",
    "prescription_id",
    "progressor_id",
    "tolerable",
    "user_id"
FROM   "Exercise"
WHERE  "id"              LIKE '%' || ? || '%'
OR     "user_id"         LIKE '%' || ? || '%'
OR     "prescription_id" LIKE '%' || ? || '%'
OR     "datetime"        LIKE '%' || ? || '%';
''';

const _insert = '''
INSERT INTO "Exercise" (
    "completed",
    "data",
    "datetime",
    "mvc_value",
    "pain_score",
    "prescription_id",
    "progressor_id",
    "tolerable",
    "user_id"
)
VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);
''';

const _update = '''
UPDATE "Exercise"
SET    "completed"       = ?,
       "data"            = ?,
       "datetime"        = ?,
       "mvc_value"       = ?,
       "pain_score"      = ?,
       "prescription_id" = ?,
       "progressor_id"   = ?,
       "tolerable"       = ?,
       "user_id"         = ?
WHERE  "id"              = ?;
''';

const _delete = '''
DELETE FROM "Exercise"
WHERE "id" = ?;
''';
