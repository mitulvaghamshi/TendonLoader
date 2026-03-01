import 'package:api_server/sql/prescription_table.dart';
import 'package:sqlite3/sqlite3.dart';

class PrescriptionService {
  const PrescriptionService(this.db);

  final Database db;

  ResultSet selectAll() {
    return db.select(PrescriptionTable.sqlSelectAll);
  }

  ResultSet selectBy(int? id) {
    return db.select(PrescriptionTable.sqlSelectById, [id]);
  }

  ResultSet search(String? term) {
    return db.select(PrescriptionTable.sqlSearch, [term]);
  }

  ResultSet insert({
    required int sets,
    required int reps,
    required int setRest,
    required int holdTime,
    required int restTime,
    required int mvcDuration,
    required double targetLoad,
  }) {
    return db.select(PrescriptionTable.sqlInsert, [
      reps,
      sets,
      setRest,
      holdTime,
      restTime,
      mvcDuration,
      targetLoad,
    ]);
  }

  ResultSet update({
    required int? id,
    required int sets,
    required int reps,
    required int setRest,
    required int holdTime,
    required int restTime,
    required int mvcDuration,
    required double targetLoad,
  }) {
    return db.select(PrescriptionTable.sqlUpdate, [
      reps,
      sets,
      setRest,
      holdTime,
      restTime,
      mvcDuration,
      targetLoad,
      id,
    ]);
  }

  ResultSet delete(int? id) {
    return db.select(PrescriptionTable.sqlDelete, [id]);
  }
}
