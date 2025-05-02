import 'package:server/utils/config.dart';
import 'package:server/utils/stmt_type.dart';
import 'package:sqlite3/sqlite3.dart';

ResultSet get selectAll {
  return settingsStmt[StmtType.query.index].selectWith(
    const StatementParameters.empty(),
  );
}

ResultSet selectBy(int? id) {
  return settingsStmt[StmtType.select.index].selectWith(
    StatementParameters.named({':id': id}),
  );
}

ResultSet selectByUser(String? id) => search(id);

ResultSet search(String? term) {
  return settingsStmt[StmtType.search.index].selectWith(
    StatementParameters.named({':q': term}),
  );
}

ResultSet insert({
  required int? userId,
  required int? prescriptionId,
  required bool darkMode,
  required bool autoUpload,
  required bool editablePrescription,
  required double graphScale,
}) {
  return settingsStmt[StmtType.insert.index].selectWith(
    StatementParameters.named({
      ':user_id': userId,
      ':prescription_id': prescriptionId,
      ':dark_mode': darkMode,
      ':auto_upload': autoUpload,
      ':editable_prescription': editablePrescription,
      ':graph_scale': graphScale,
    }),
  );
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
  return settingsStmt[StmtType.update.index].selectWith(
    StatementParameters.named({
      ':id': id,
      ':user_id': userId,
      ':prescription_id': prescriptionId,
      ':dark_mode': darkMode,
      ':auto_upload': autoUpload,
      ':editable_prescription': editablePrescription,
      ':graph_scale': graphScale,
    }),
  );
}

ResultSet delete(int? id) {
  return settingsStmt[StmtType.delete.index].selectWith(
    StatementParameters.named({':id': id}),
  );
}
