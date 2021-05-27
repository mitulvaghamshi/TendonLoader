import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tendon_loader/app/handler/bluetooth_handler.dart';
import 'package:tendon_loader/app/handler/data_handler.dart';
import 'package:tendon_loader/app/handler/location_handler.dart';
import 'package:tendon_loader/shared/app_auth.dart';
import 'package:tendon_loader/shared/constants.dart';
import 'package:wakelock/wakelock.dart';

mixin Setup {
  static final Completer<void> _completer = Completer<void>();

  static Future<void> start() async {
    if (!_completer.isCompleted) {
      await AppAuth.init();
      await Hive.initFlutter();
      await Hive.openBox<Object>(Keys.KEY_LOGIN_BOX);
      if (!kIsWeb) {
        await Hive.openBox<Map<dynamic, dynamic>>(Keys.KEY_USER_EXPORTS_BOX);
        await Locator.check();
        await KPlayer.load();
      }
      await Wakelock.enable();
      Future<void>.delayed(const Duration(seconds: 2), () => _completer.complete());
    }
    return _completer.future;
  }

  static Future<bool> dispose() async {
    await Wakelock.disable();
    await Bluetooth.disconnect();
    await AppAuth.signOut();
    await Hive.close();
    Locator.dispose();
    DataHandler.dataDispose();
    return true;
  }
}
