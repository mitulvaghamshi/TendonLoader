import 'package:sqlite3/sqlite3.dart';

class PrescriptionService {
  const PrescriptionService(this.db);

  final Database db;

  ResultSet selectAll() => db.select(_selectAll);

  ResultSet selectBy(int? id) => db.select(_selectById, [id]);

  ResultSet search(String? term) => db.select(_search, [term]);

  ResultSet insert({
    required int sets,
    required int reps,
    required int setRest,
    required int holdTime,
    required int restTime,
    required int mvcDuration,
    required double targetLoad,
  }) => db.select(_insert, [
    reps,
    sets,
    setRest,
    holdTime,
    restTime,
    mvcDuration,
    targetLoad,
  ]);

  ResultSet update({
    required int? id,
    required int sets,
    required int reps,
    required int setRest,
    required int holdTime,
    required int restTime,
    required int mvcDuration,
    required double targetLoad,
  }) => db.select(_update, [
    reps,
    sets,
    setRest,
    holdTime,
    restTime,
    mvcDuration,
    targetLoad,
    id,
  ]);

  ResultSet delete(int? id) => db.select(_delete, [id]);
}

// ignore: unused_element
const _createTable = '''
CREATE TABLE IF NOT EXISTS "Prescription" (
    "id"           INTEGER NOT NULL CONSTRAINT "PK_Prescription" PRIMARY KEY AUTOINCREMENT,
    "reps"         INTEGER NOT NULL,
    "sets"         INTEGER NOT NULL,
    "set_rest"     INTEGER NOT NULL,
    "hold_time"    INTEGER NOT NULL,
    "rest_time"    INTEGER NOT NULL,
    "mvc_duration" INTEGER NOT NULL,
    "target_load"  REAL    NOT NULL
);
''';

const _selectAll = '''
SELECT
    "id",
    "reps",
    "sets",
    "set_rest",
    "hold_time",
    "rest_time",
    "mvc_duration",
    "target_load"
FROM "Prescription";
''';

const _selectById = '''
SELECT
    "id",
    "reps",
    "sets",
    "set_rest",
    "hold_time",
    "rest_time",
    "mvc_duration",
    "target_load"
FROM "Prescription"
WHERE "id" = ?;
''';

const _search = '''
SELECT
    "id",
    "reps",
    "sets",
    "set_rest",
    "hold_time",
    "rest_time",
    "mvc_duration",
    "target_load"
FROM "Prescription"
WHERE "id" LIKE "%" || ? || "%";
''';

const _insert = '''
INSERT INTO "Prescription" (
    "reps",
    "sets",
    "set_rest",
    "hold_time",
    "rest_time",
    "mvc_duration",
    "target_load"
)
VALUES (?, ?, ?, ?, ?, ?, ?);
''';

const _update = '''
UPDATE "Prescription"
SET    "reps"         = ?,
       "sets"         = ?,
       "set_rest"     = ?,
       "hold_time"    = ?,
       "rest_time"    = ?,
       "mvc_duration" = ?,
       "target_load"  = ?
WHERE  "id"           = ?;
''';

const _delete = '''
DELETE FROM "Prescription"
WHERE "id" = ?;
''';
