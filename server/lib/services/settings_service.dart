import 'package:sqlite3/sqlite3.dart';

class SettingsService {
  const SettingsService(this.db);

  final Database db;

  ResultSet selectAll() => db.select(_selectAll);

  ResultSet selectBy(int? id) => db.select(_selectById, [id]);

  ResultSet selectByUser(String? id) => search(id);

  ResultSet search(String? term) => db.select(_search, [term]);

  ResultSet insert({
    required int? userId,
    required int? prescriptionId,
    required bool darkMode,
    required bool autoUpload,
    required bool editablePrescription,
    required double graphScale,
  }) => db.select(_insert, [
    if (autoUpload) 1 else 0,
    if (darkMode) 1 else 0,
    if (editablePrescription) 1 else 0,
    graphScale,
    prescriptionId,
    userId,
  ]);

  ResultSet update({
    required int? id,
    required int? userId,
    required int? prescriptionId,
    required bool darkMode,
    required bool autoUpload,
    required bool editablePrescription,
    required double graphScale,
  }) => db.select(_update, [
    if (autoUpload) 1 else 0,
    if (darkMode) 1 else 0,
    if (editablePrescription) 1 else 0,
    graphScale,
    prescriptionId,
    userId,
    id,
  ]);

  ResultSet delete(int? id) => db.select(_delete, [id]);
}

// ignore: unused_element
const _createTable = '''
CREATE TABLE IF NOT EXISTS "Settings" (
    "id"                    INTEGER NOT NULL CONSTRAINT "PK_Settings" PRIMARY KEY AUTOINCREMENT,
    "auto_upload"           INTEGER NOT NULL,
    "dark_mode"             INTEGER NOT NULL,
    "editable_prescription" INTEGER NOT NULL,
    "graph_scale"           REAL    NOT NULL,
    "prescription_id"       INTEGER     NULL,
    "user_id"               INTEGER NOT NULL
);
''';

const _selectAll = '''
SELECT
    "id",
    "auto_upload",
    "dark_mode",
    "editable_prescription",
    "graph_scale",
    "prescription_id",
    "user_id"
FROM "Settings";
''';

const _selectById = '''
SELECT
    "id",
    "auto_upload",
    "dark_mode",
    "editable_prescription",
    "graph_scale",
    "prescription_id",
    "user_id"
FROM "Settings"
WHERE "id" = ?;
''';

const _search = '''
SELECT
    "id",
    "auto_upload",
    "dark_mode",
    "editable_prescription",
    "graph_scale",
    "prescription_id",
    "user_id"
FROM "Settings"
WHERE "user_id" = ?;
''';

const _insert = '''
INSERT INTO "Settings" (
    "auto_upload",
    "dark_mode",
    "editable_prescription",
    "graph_scale",
    "prescription_id",
    "user_id"
)
VALUES (?, ?, ?, ?, ?, ?);
''';

const _update = '''
UPDATE "Settings"
SET    "auto_upload"           = ?,
       "dark_mode"             = ?,
       "editable_prescription" = ?,
       "graph_scale"           = ?,
       "prescription_id"       = ?,
       "user_id"               = ?
WHERE  "id"                    = ?;
''';

const _delete = '''
DELETE FROM "Settings"
WHERE "id" = ?;
''';
