import 'package:server/statements/prescription_statements.dart';
import 'package:server/utils/stmt_type.dart';
import 'package:sqlite3/sqlite3.dart';

extension PrescriptionService on PrescriptionStatements {
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
    required int sets,
    required int reps,
    required int setRest,
    required int holdTime,
    required int restTime,
    required int mvcDuration,
    required double targetLoad,
  }) {
    stmts[StmtType.insert.index].executeWith(
      StatementParameters.named({
        ':reps': reps,
        ':sets': sets,
        ':setRest': setRest,
        ':holdTime': holdTime,
        ':restTime': restTime,
        ':mvcDuration': mvcDuration,
        ':targetLoad': targetLoad,
      }),
    );
  }

  void update({
    required int? id,
    required int sets,
    required int reps,
    required int setRest,
    required int holdTime,
    required int restTime,
    required int mvcDuration,
    required double targetLoad,
  }) {
    stmts[StmtType.update.index].executeWith(
      StatementParameters.named({
        'id': id,
        'reps': reps,
        'sets': sets,
        'setRest': setRest,
        'holdTime': holdTime,
        'restTime': restTime,
        'mvcDuration': mvcDuration,
        'targetLoad': targetLoad,
      }),
    );
  }

  void delete(int id) {
    stmts[StmtType.delete.index].executeWith(
      StatementParameters.named({':id': id}),
    );
  }
}
