import 'package:server/router/exercise_router.dart';
import 'package:server/router/prescription_router.dart';
import 'package:server/router/settings_router.dart';
import 'package:server/router/user_router.dart';
import 'package:server/statements/exercise_statements.dart';
import 'package:server/statements/prescription_statements.dart';
import 'package:server/statements/settings_statements.dart';
import 'package:server/statements/user_statements.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:sqlite3/sqlite3.dart';

class AppDatabase {
  const AppDatabase({
    required this.inMemory,
    required this.database,
    required this.userStmt,
    required this.settingsStmt,
    required this.exerciseStmt,
    required this.prescriptionStmt,
  });

  factory AppDatabase.open() {
    const dbPath = String.fromEnvironment('DB_PATH');
    final database =
        dbPath.isEmpty ? sqlite3.openInMemory() : sqlite3.open(dbPath);

    return AppDatabase(
      inMemory: dbPath.isEmpty,
      database: database,
      userStmt: UserStatements.fromEnv(),
      settingsStmt: SettingsStatements.fromEnv(),
      exerciseStmt: ExerciseStatements.fromEnv(),
      prescriptionStmt: PrescriptionStatements.fromEnv(),
    );
  }

  final bool inMemory;
  final Database database;
  final UserStatements userStmt;
  final SettingsStatements settingsStmt;
  final ExerciseStatements exerciseStmt;
  final PrescriptionStatements prescriptionStmt;
}

extension Utils on AppDatabase {
  Future<void> init() async => Future.wait([
    userStmt.prepare(database),
    settingsStmt.prepare(database),
    exerciseStmt.prepare(database),
    prescriptionStmt.prepare(database),
  ]);

  void dispose() => database.dispose();
}

extension RootRouter on AppDatabase {
  Router get router =>
      Router() //
        // curl http://localhost:8080
        ..get('/', _rootHandler)
        // curl http://localhost:8080/users
        ..mount('/users', userStmt.userRouter.call)
        // curl http://localhost:8080/settings
        ..mount('/settings', settingsStmt.settingsRouter.call)
        // curl http://localhost:8080/exercises
        ..mount('/exercises', exerciseStmt.exerciseRouter.call)
        // curl http://localhost:8080/prescription
        ..mount('/prescriptions', prescriptionStmt.prescriptionRouter.call);

  Response _rootHandler(Request request) =>
      Response.ok('<h2>Welcome to TendonLoader API v1.0</h2>\n');
}
