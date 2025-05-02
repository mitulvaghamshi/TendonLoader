import 'package:server/utils/config.dart';
import 'package:server/utils/stmt_type.dart';
import 'package:sqlite3/sqlite3.dart';

ResultSet get selectAll {
  return exerciseStmt[StmtType.query.index].selectWith(
    const StatementParameters.empty(),
  );
}

ResultSet selectBy(int id) {
  return exerciseStmt[StmtType.select.index].selectWith(
    StatementParameters.named({':id': id}),
  );
}

ResultSet search(String term) {
  return exerciseStmt[StmtType.search.index].selectWith(
    StatementParameters.named({':q': term}),
  );
}

ResultSet insert({
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
  return exerciseStmt[StmtType.insert.index].selectWith(
    StatementParameters.named({
      ':user_id': userId,
      ':prescription_id': prescriptionId,
      ':pain_score': painScore,
      ':datetime': datetime,
      ':tolerable': tolerable,
      ':completed': completed,
      ':progressor_id': progressorId,
      ':mvc_value': mvcValue,
      ':data': data,
    }),
  );
}

ResultSet update({
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
  return exerciseStmt[StmtType.update.index].selectWith(
    StatementParameters.named({
      ':id': id,
      ':user_id': userId,
      ':prescription_id': painScore,
      ':pain_score': datetime,
      ':datetime': tolerable,
      ':tolerable': completed,
      ':completed': progressorId,
      ':progressor_id': prescriptionId,
      ':mvc_value': mvcValue,
      ':data': data,
    }),
  );
}

ResultSet delete(int id) {
  return exerciseStmt[StmtType.delete.index].selectWith(
    StatementParameters.named({':id': id}),
  );
}
