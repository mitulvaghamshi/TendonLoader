import 'package:server/utils/config.dart';
import 'package:server/utils/stmt_type.dart';
import 'package:sqlite3/sqlite3.dart';

ResultSet get selectAll =>
    settingsStmt[StmtType.query.index].selectWith(const .empty());

ResultSet selectBy(int? id) =>
    settingsStmt[StmtType.select.index].selectWith(.named({':id': id}));

ResultSet selectByUser(String? id) => search(id);

ResultSet search(String? term) =>
    settingsStmt[StmtType.search.index].selectWith(.named({':q': term}));

ResultSet insert({
  required int? userId,
  required int? prescriptionId,
  required bool darkMode,
  required bool autoUpload,
  required bool editablePrescription,
  required double graphScale,
}) => settingsStmt[StmtType.insert.index].selectWith(
  .named({
    ':user_id': userId,
    ':prescription_id': prescriptionId,
    ':dark_mode': darkMode,
    ':auto_upload': autoUpload,
    ':editable_prescription': editablePrescription,
    ':graph_scale': graphScale,
  }),
);

ResultSet update({
  required int? id,
  required int? userId,
  required int? prescriptionId,
  required bool darkMode,
  required bool autoUpload,
  required bool editablePrescription,
  required double graphScale,
}) => settingsStmt[StmtType.update.index].selectWith(
  .named({
    ':id': id,
    ':user_id': userId,
    ':prescription_id': prescriptionId,
    ':dark_mode': darkMode,
    ':auto_upload': autoUpload,
    ':editable_prescription': editablePrescription,
    ':graph_scale': graphScale,
  }),
);

ResultSet delete(int? id) =>
    settingsStmt[StmtType.delete.index].selectWith(.named({':id': id}));
