import 'package:server/sql/table_exercise.dart';
import 'package:sqlite3/sqlite3.dart';

class ExerciseService {
  const ExerciseService(this.db);

  final Database db;

  ResultSet selectAll() {
    return db.select(TableExercise.sqlSelectAll);
  }

  ResultSet selectBy(int id) {
    return db.select(TableExercise.sqlSelectById, [id]);
  }

  ResultSet search(String term) {
    return db.select(TableExercise.sqlSearch, [term, term, term, term]);
  }

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
  }) {
    return db.select(TableExercise.sqlInsert, [
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
  }

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
  }) {
    return db.select(TableExercise.sqlUpdate, [
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
  }

  ResultSet delete(int id) {
    return db.select(TableExercise.sqlDelete, [id]);
  }
}
