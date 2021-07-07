import 'package:connectivity/connectivity.dart';
import 'package:tendon_loader/login/initializer.dart';

Future<bool> get isConnected async => (await Connectivity().checkConnectivity()) != ConnectivityResult.none;

int get localDataCount => boxExport.length;
