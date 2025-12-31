import 'package:server/utils/config.dart';
import 'package:server/utils/stmt_type.dart';
import 'package:sqlite3/sqlite3.dart';

ResultSet get selectAll =>
    prescriptionStmt[StmtType.query.index].selectWith(const .empty());

ResultSet selectBy(int? id) =>
    prescriptionStmt[StmtType.select.index].selectWith(.named({':id': id}));

ResultSet search(String? term) =>
    prescriptionStmt[StmtType.search.index].selectWith(.named({':q': term}));

ResultSet insert({
  required int sets,
  required int reps,
  required int setRest,
  required int holdTime,
  required int restTime,
  required int mvcDuration,
  required double targetLoad,
}) => prescriptionStmt[StmtType.insert.index].selectWith(
  .named({
    ':reps': reps,
    ':sets': sets,
    ':set_rest': setRest,
    ':hold_time': holdTime,
    ':rest_time': restTime,
    ':mvc_duration': mvcDuration,
    ':target_load': targetLoad,
  }),
);

ResultSet update({
  required int? id,
  required int sets,
  required int reps,
  required int setRest,
  required int holdTime,
  required int restTime,
  required int mvcDuration,
  required double targetLoad,
}) => prescriptionStmt[StmtType.update.index].selectWith(
  .named({
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

ResultSet delete(int? id) =>
    prescriptionStmt[StmtType.delete.index].selectWith(.named({':id': id}));
