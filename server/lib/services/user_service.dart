import 'package:server/statements/user_statements.dart';
import 'package:server/utils/stmt_type.dart';
import 'package:sqlite3/sqlite3.dart';

extension UserService on UserStatements {
  ResultSet auth(String username, String password) {
    return stmts[StmtType.auth.index].selectWith(
      StatementParameters.named({':username': username, ':password': password}),
    );
  }

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

  void insert({required String username, required String password}) {
    stmts[StmtType.insert.index].executeWith(
      StatementParameters.named({':username': username, ':password': password}),
    );
  }

  void update({
    required int id,
    required String username,
    required String password,
  }) {
    stmts[StmtType.update.index].executeWith(
      StatementParameters.named({
        ':id': id,
        ':username': username,
        ':password': password,
      }),
    );
  }

  void delete(int id) {
    stmts[StmtType.delete.index].executeWith(
      StatementParameters.named({':id': id}),
    );
  }
}
