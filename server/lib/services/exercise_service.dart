import 'package:server/statements/exercise_statements.dart';
import 'package:server/utils/stmt_type.dart';
import 'package:sqlite3/sqlite3.dart';

extension ExerciseService on ExerciseStatements {
  ResultSet get selectAll => stmts[StmtType.query.index].select();

  ResultSet selectBy(int id) {
    return stmts[StmtType.select.index].selectWith(
      StatementParameters.named({':id': id}),
    );
  }

  ResultSet search(String term) {
    return stmts[StmtType.search.index].selectWith(
      StatementParameters.named({':q': term}),
    );
  }

  void insert({
    required int userId,
    required double painScore,
    required String datetime,
    required String tolerable,
    required int /* bool */ completed,
    required String progressorId,
    required int? prescriptionId,
    required double? mvcValue,
    required String data,
  }) {
    stmts[StmtType.insert.index].executeWith(
      StatementParameters.named({
        ':userId': userId,
        ':painScore': painScore,
        ':datetime': datetime,
        ':tolerable': tolerable,
        ':completed': completed,
        ':progressorId': progressorId,
        ':prescriptionId': prescriptionId,
        ':mvcValue': mvcValue,
        ':data': data,
      }),
    );
  }

  void update({
    required int id,
    required int userId,
    required double painScore,
    required String datetime,
    required String tolerable,
    required int /* bool */ completed,
    required String progressorId,
    required int? prescriptionId,
    required double? mvcValue,
    required String data,
  }) {
    stmts[StmtType.update.index].executeWith(
      StatementParameters.named({
        ':id': id,
        ':userId': userId,
        ':painScore': painScore,
        ':datetime': datetime,
        ':tolerable': tolerable,
        ':completed': completed,
        ':progressorId': progressorId,
        ':prescriptionId': prescriptionId,
        ':mvcValue': mvcValue,
        ':data': data,
      }),
    );
  }

  void delete(int id) {
    stmts[StmtType.delete.index].executeWith(
      StatementParameters.named({':id': id}),
    );
  }
}
