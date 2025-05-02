import 'package:server/utils/config.dart';
import 'package:server/utils/stmt_type.dart';
import 'package:sqlite3/sqlite3.dart';

ResultSet auth(String username, String password) {
  return userStmt[StmtType.auth.index].selectWith(
    StatementParameters.named({':username': username, ':password': password}),
  );
}

ResultSet get selectAll {
  return userStmt[StmtType.query.index].selectWith(
    const StatementParameters.empty(),
  );
}

ResultSet selectBy(int id) {
  return userStmt[StmtType.select.index].selectWith(
    StatementParameters.named({':id': id}),
  );
}

ResultSet search(String term) {
  return userStmt[StmtType.search.index].selectWith(
    StatementParameters.named({':q': term}),
  );
}

ResultSet insert({required String username, required String password}) {
  return userStmt[StmtType.insert.index].selectWith(
    StatementParameters.named({':username': username, ':password': password}),
  );
}

ResultSet update({
  required int id,
  required String username,
  required String password,
}) {
  return userStmt[StmtType.update.index].selectWith(
    StatementParameters.named({
      ':id': id,
      ':username': username,
      ':password': password,
    }),
  );
}

ResultSet delete(int? id) {
  return userStmt[StmtType.delete.index].selectWith(
    StatementParameters.named({':id': id}),
  );
}
