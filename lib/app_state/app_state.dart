import 'dart:collection';

import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/modal/patient.dart';
import 'package:tendon_loader/utils/common.dart';

class AppState {
  final Map<int, Patient> users = HashMap<int, Patient>();

  late Iterable<int> userList = users.keys;
  late Iterable<Export>? exportList = users[userNotifier.value]?.exports;
}
