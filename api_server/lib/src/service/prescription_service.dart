import 'package:api_server/src/sql/table_prescription.dart';
import 'package:sqlite3/sqlite3.dart';

class PrescriptionService {
  const PrescriptionService(this.db);

  final Database db;

  ResultSet selectAll() {
    return db.select(TablePrescription.sqlSelectAll);
  }

  ResultSet selectBy(int? id) {
    return db.select(TablePrescription.sqlSelectById, [id]);
  }

  ResultSet search(String? term) {
    return db.select(TablePrescription.sqlSearch, [term]);
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
    return db.select(TablePrescription.sqlInsert, [
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
    return db.select(TablePrescription.sqlUpdate, [
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
    return db.select(TablePrescription.sqlDelete, [id]);
  }
}
