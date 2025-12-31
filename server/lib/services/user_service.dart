import 'package:server/utils/config.dart';
import 'package:server/utils/stmt_type.dart';
import 'package:sqlite3/sqlite3.dart';

ResultSet auth(String username, String password) =>
    userStmt[StmtType.auth.index].selectWith(
      .named({':username': username, ':password': password}),
    );

ResultSet get selectAll =>
    userStmt[StmtType.query.index].selectWith(const .empty());

ResultSet selectBy(int id) =>
    userStmt[StmtType.select.index].selectWith(.named({':id': id}));

ResultSet search(String term) =>
    userStmt[StmtType.search.index].selectWith(.named({':q': term}));

ResultSet insert({required String username, required String password}) =>
    userStmt[StmtType.insert.index].selectWith(
      .named({':username': username, ':password': password}),
    );

ResultSet update({
  required int id,
  required String username,
  required String password,
}) => userStmt[StmtType.update.index].selectWith(
  .named({':id': id, ':username': username, ':password': password}),
);

ResultSet delete(int? id) =>
    userStmt[StmtType.delete.index].selectWith(.named({':id': id}));
