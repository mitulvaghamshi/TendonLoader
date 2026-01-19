import 'package:server/sql/table_settings.dart';
import 'package:sqlite3/sqlite3.dart';

class SettingsService {
  const SettingsService(this.db);

  final Database db;

  ResultSet selectAll() => db.select(TableSettings.sqlSelectAll);

  ResultSet selectBy(int? id) => db.select(TableSettings.sqlSelectById, [id]);

  ResultSet selectByUser(String? id) => search(id);

  ResultSet search(String? term) => db.select(TableSettings.sqlSearch, [term]);

  ResultSet insert({
    required int? userId,
    required int? prescriptionId,
    required bool darkMode,
    required bool autoUpload,
    required bool editablePrescription,
    required double graphScale,
  }) => db.select(TableSettings.sqlInsert, [
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
  }) => db.select(TableSettings.sqlUpdate, [
    if (autoUpload) 1 else 0,
    if (darkMode) 1 else 0,
    if (editablePrescription) 1 else 0,
    graphScale,
    prescriptionId,
    userId,
    id,
  ]);

  ResultSet delete(int? id) => db.select(TableSettings.sqlDelete, [id]);
}
