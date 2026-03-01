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

      if (result.isEmpty || result.single.isEmpty) {
        return const .error('Not Found');
      }

      final dbUser = result.single;
      final token = _uuid.v1();

      // Store session in DB
      db.select(TableAuth.sqlInsert, [
        dbUser[TableAuth.id],
        token,
        DateTime.now().toIso8601String(),
      ]);

      return .data(
        const User.empty().copyWith(
          id: dbUser[UserTable.kId],
          username: dbUser[UserTable.kUsername],
          password: dbUser[UserTable.kPassword],
          role: dbUser[UserTable.kRole],
          token: token,
        ),
      );
    } on SqliteException catch (e) {
      return .error(e.message);
    }
  }

  Snapshot<User> authorize(String token) {
    try {
      final result = db.select(
        '''
        SELECT u.${UserTable.kId}, u.${UserTable.kUsername}, u.${UserTable.kPassword}, u.${UserTable.kRole}
        FROM ${UserTable.kTable} u
        INNER JOIN ${TableAuth.table} a ON u.${UserTable.kId} = a.${TableAuth.userId}
        WHERE a.${TableAuth.token} = ?
        ''',
        [token],
      );

      if (result.isEmpty) {
        return const .error('Unauthorized');
      }

      final authUser = result.single;
      return .data(
        const User.empty().copyWith(
          id: authUser[UserTable.kId],
          username: authUser[UserTable.kUsername],
          password: authUser[UserTable.kPassword],
          role: authUser[UserTable.kRole],
          token: token,
        ),
      );
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
