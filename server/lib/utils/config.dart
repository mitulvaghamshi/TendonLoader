import 'package:server/app_database.dart';
import 'package:shelf/shelf.dart';

class Config {
  const Config._({required AppDatabase database}) : _database = database;

  factory Config.fromEnv() => Config._(database: AppDatabase.open());

  final AppDatabase _database;
}

extension Utils on Config {
  Future<Response> Function(Request) get rootHandler => _database.router.call;

  Future<void> init() async => _database.init();
}
