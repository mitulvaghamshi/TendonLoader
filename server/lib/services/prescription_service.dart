import 'package:server/utils/config.dart';
import 'package:server/utils/stmt_type.dart';
import 'package:sqlite3/sqlite3.dart';

ResultSet get selectAll {
  return prescriptionStmt[StmtType.query.index].selectWith(
    const StatementParameters.empty(),
  );
}

ResultSet selectBy(int? id) {
  return prescriptionStmt[StmtType.select.index].selectWith(
    StatementParameters.named({':id': id}),
  );
}

ResultSet search(String? term) {
  return prescriptionStmt[StmtType.search.index].selectWith(
    StatementParameters.named({':q': term}),
  );
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
  return prescriptionStmt[StmtType.insert.index].selectWith(
    StatementParameters.named({
      ':reps': reps,
      ':sets': sets,
      ':set_rest': setRest,
      ':hold_time': holdTime,
      ':rest_time': restTime,
      ':mvc_duration': mvcDuration,
      ':target_load': targetLoad,
    }),
  );
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
  return prescriptionStmt[StmtType.update.index].selectWith(
    StatementParameters.named({
      'id': id,
      'reps': reps,
      'sets': sets,
      'set_rest': setRest,
      'hold_time': holdTime,
      'rest_time': restTime,
      'mvc_duration': mvcDuration,
      'target_load': targetLoad,
    }),
  );
}

ResultSet delete(int? id) {
  return prescriptionStmt[StmtType.delete.index].selectWith(
    StatementParameters.named({':id': id}),
  );
}
