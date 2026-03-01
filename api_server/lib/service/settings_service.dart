import 'package:api_server/sql/settings_table.dart';
import 'package:sqlite3/sqlite3.dart';

class SettingsService {
  const SettingsService(this.db);

  final Database db;

  ResultSet selectAll() {
    return db.select(SettingsTable.sqlSelectAll);
  }

  ResultSet selectBy(int? id) {
    return db.select(SettingsTable.sqlSelectById, [id]);
  }

  ResultSet selectByUser(String? id) {
    return search(id);
  }

  ResultSet search(String? term) {
    return db.select(SettingsTable.sqlSearch, [term]);
  }

  ResultSet insert({
    required int? userId,
    required int? prescriptionId,
    required bool darkMode,
    required bool autoUpload,
    required bool editablePrescription,
    required double graphScale,
  }) {
    return db.select(SettingsTable.sqlInsert, [
      if (autoUpload) 1 else 0,
      if (darkMode) 1 else 0,
      if (editablePrescription) 1 else 0,
      graphScale,
      prescriptionId,
      userId,
    ]);
  }

  ResultSet update({
    required int? id,
    required int? userId,
    required int? prescriptionId,
    required bool darkMode,
    required bool autoUpload,
    required bool editablePrescription,
    required double graphScale,
  }) {
    return db.select(SettingsTable.sqlUpdate, [
      if (autoUpload) 1 else 0,
      if (darkMode) 1 else 0,
      if (editablePrescription) 1 else 0,
      graphScale,
      prescriptionId,
      userId,
      id,
    ]);
  }

  ResultSet delete(int? id) {
    return db.select(SettingsTable.sqlDelete, [id]);
  }
}
