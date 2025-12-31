import 'package:server/utils/config.dart';
import 'package:server/utils/stmt_type.dart';
import 'package:sqlite3/sqlite3.dart';

ResultSet get selectAll =>
    exerciseStmt[StmtType.query.index].selectWith(const .empty());

ResultSet selectBy(int id) =>
    exerciseStmt[StmtType.select.index].selectWith(.named({':id': id}));

ResultSet search(String term) =>
    exerciseStmt[StmtType.search.index].selectWith(.named({':q': term}));

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
}) => exerciseStmt[StmtType.insert.index].selectWith(
  .named({
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
}) => exerciseStmt[StmtType.update.index].selectWith(
  .named({
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

ResultSet delete(int id) =>
    exerciseStmt[StmtType.delete.index].selectWith(.named({':id': id}));
