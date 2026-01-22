import 'package:server/models/user.dart';
import 'package:server/sql/table_auth.dart';
import 'package:server/sql/table_user.dart';
import 'package:server/utils/config.dart';
import 'package:server/utils/snapshot.dart';
import 'package:sqlite3/sqlite3.dart';

class UserService {
  const UserService(this.db);

  final Database db;

  void init() {
    db.execute(TableUser.sqlCreateTable);
    db.execute(TableAuth.sqlCreateTable);
  }

  Snapshot<User> authenticate({required User user}) {
    try {
      final result = db.select(TableUser.sqlAuth, [
        user.username,
        user.password,
      ]);

      if (result.isEmpty || result.single.isEmpty) {
        return const .error('Not Found');
      }

      final dbUser = result.single;
      final token = Config.uuid.v1();

      // Store session in DB
      db.select(TableAuth.sqlInsert, [
        dbUser[TableAuth.id],
        token,
        DateTime.now().toIso8601String(),
      ]);

      return .data(
        const User.empty().copyWith(
          id: dbUser[TableUser.id],
          username: dbUser[TableUser.username],
          password: dbUser[TableUser.password],
          role: dbUser[TableUser.role],
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
        SELECT u.${TableUser.id}, u.${TableUser.username}, u.${TableUser.password}, u.${TableUser.role}
        FROM ${TableUser.table} u
        INNER JOIN ${TableAuth.table} a ON u.${TableUser.id} = a.${TableAuth.userId}
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
          id: authUser[TableUser.id],
          username: authUser[TableUser.username],
          password: authUser[TableUser.password],
          role: authUser[TableUser.role],
          token: token,
        ),
      );
    } on SqliteException catch (e) {
      return .error(e.message);
    }
  }

  ResultSet selectAll() {
    return db.select(TableUser.sqlSelectAll);
  }

  ResultSet selectBy({required int userId}) {
    return db.select(TableUser.sqlSelectById, [userId]);
  }

  ResultSet search(String term) {
    return db.select(TableUser.sqlSearch, [term]);
  }

  ResultSet insert({required User user}) {
    return db.select(TableUser.sqlInsert, [
      user.username,
      user.password,
      user.role,
    ]);
  }

  ResultSet update({required User user}) {
    return db.select(TableUser.sqlUpdate, [
      user.username,
      user.password,
      user.role,
      user.id,
    ]);
  }

  ResultSet delete({required int userId}) {
    return db.select(TableUser.sqlDelete, [userId]);
  }
}
