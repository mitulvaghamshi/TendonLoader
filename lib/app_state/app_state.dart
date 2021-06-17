import 'package:hive/hive.dart';
import 'package:tendon_loader_lib/tendon_loader_lib.dart';

class AppState {
  String? userId;

  bool? autoUpload;
  bool? fieldEditable;

  Future<void> getSettings() async {
    final Box<Map<dynamic, dynamic>> _settingsBox = Hive.box(keyAppSettingsBox);
    if (_settingsBox.containsKey(keyAppSettingsBox)) {
      final Map<String, dynamic> _settings = Map<String, dynamic>.from(_settingsBox.get(keyAppSettingsBox)!);
      autoUpload = _settings['_key_auto_upload'] as bool? ?? false;
      fieldEditable = _settings['_key_exercise_editable'] as bool? ?? false;
    } else {
      autoUpload = false;
      fieldEditable = true;
    }
  }

  Future<bool> updateSettings() async {
    await Hive.box<Map<dynamic, dynamic>>(keyAppSettingsBox).put(keyAppSettingsBox, <String, dynamic>{
      '_key_auto_upload': autoUpload,
      '_key_exercise_editable': fieldEditable,
    });
    return true;
  }
}
