import 'package:server/statements/settings_statements.dart';
import 'package:server/utils/stmt_type.dart';
import 'package:sqlite3/sqlite3.dart';

extension SettingsService on SettingsStatements {
  ResultSet get selectAll => stmts[StmtType.query.index].select();

  ResultSet selectBy(int? id) {
    return stmts[StmtType.select.index].selectWith(
      StatementParameters.named({':id': id}),
    );
  }

  ResultSet selectByUser(String? id) => search(id);

  ResultSet search(String? term) {
    return stmts[StmtType.search.index].selectWith(
      StatementParameters.named({':q': term}),
    );
  }

  void insert({
    required int? userId,
    required int? prescriptionId,
    required bool darkMode,
    required bool autoUpload,
    required bool editablePrescription,
    required double graphScale,
  }) {
    stmts[StmtType.insert.index].executeWith(
      StatementParameters.named({
        ':userId': userId,
        ':prescriptionId': prescriptionId,
        ':darkMode': darkMode,
        ':autoUpload': autoUpload,
        ':editablePrescriprion': editablePrescription,
        ':graphScale': graphScale,
      }),
    );
  }

  void update({
    required int? id,
    required int? userId,
    required int? prescriptionId,
    required bool darkMode,
    required bool autoUpload,
    required bool editablePrescription,
    required double graphScale,
  }) {
    stmts[StmtType.update.index].executeWith(
      StatementParameters.named({
        ':id': id,
        ':userId': userId,
        ':prescriptionId': prescriptionId,
        ':darkMode': darkMode,
        ':autoUpload': autoUpload,
        ':editablePrescriprion': editablePrescription,
        ':graphScale': graphScale,
      }),
    );
  }

  void delete(int? id) {
    stmts[StmtType.delete.index].executeWith(
      StatementParameters.named({':id': id}),
    );
  }
}
