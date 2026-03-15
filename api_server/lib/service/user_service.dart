import 'package:api_server/api_server.dart';
import 'package:api_server/sql/table_auth.dart';
import 'package:api_server/sql/user_table.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:uuid/uuid.dart';

class UserService {
  const UserService(this.db);

  final Database db;

  static const _uuid = Uuid();

  void init() {
    print('Initializing tables...');
    db.execute(UserTable.sqlCreateTable);
    db.execute(TableAuth.sqlCreateTable);
  }

  Snapshot<User> authenticate({required User user}) {
    try {
      final result = db.select(UserTable.sqlAuth, [
        user.username,
        user.password,
      ]);
      if (result.single case {
        UserTable.kId: final int? kId,
        UserTable.kUsername: final String? kUsername,
        UserTable.kPassword: final String? kPassword,
        UserTable.kRole: final String? kRole,
      }) {
        final token = _uuid.v1();
        // Store session in DB
        db.select(TableAuth.sqlInsert, [
          kId,
          token,
          DateTime.now().toIso8601String(),
        ]);
        return .data(
          const User.empty().copyWith(
            id: kId,
            username: kUsername,
            password: kPassword,
            role: kRole,
            token: token,
          ),
        );
      }
      return const .error('Not Found');
    } on SqliteException catch (e) {
      return .error(e.message);
    }
  }

  Snapshot<User> authorize(String token) {
    try {
      final result = db.select(
        '''
        SELECT
          u.${UserTable.kId},
          u.${UserTable.kUsername},
          u.${UserTable.kPassword},
          u.${UserTable.kRole}
        FROM ${UserTable.kTable} u
        INNER JOIN ${TableAuth.table} a
        ON u.${UserTable.kId} = a.${TableAuth.userId}
        WHERE a.${TableAuth.token} = (?);
        ''',
        [token],
      );
      if (result.single case {
        UserTable.kId: final int? kId,
        UserTable.kUsername: final String? kUsername,
        UserTable.kPassword: final String? kPassword,
        UserTable.kRole: final String? kRole,
      }) {
        return .data(
          const User.empty().copyWith(
            id: kId,
            username: kUsername,
            password: kPassword,
            role: kRole,
            token: token,
          ),
        );
      }
      return const .error('Unauthorized');
    } on SqliteException catch (e) {
      return .error(e.message);
    }
  }

  ResultSet selectAll() {
    return db.select(UserTable.sqlSelectAll);
  }

  ResultSet selectBy({required int userId}) {
    return db.select(UserTable.sqlSelectById, [userId]);
  }

  ResultSet search(String term) {
    return db.select(UserTable.sqlSearch, [term]);
  }

  ResultSet insert({required User user}) {
    return db.select(UserTable.sqlInsert, [
      user.username,
      user.password,
      user.role,
    ]);
  }

  ResultSet update({required User user}) {
    return db.select(UserTable.sqlUpdate, [
      user.username,
      user.password,
      user.role,
      user.id,
    ]);
  }

  ResultSet delete({required int userId}) {
    return db.select(UserTable.sqlDelete, [userId]);
  }
}
