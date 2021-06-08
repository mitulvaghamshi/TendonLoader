// todo(me): move hard-coded key to Keys mixin (constants.dart)
import 'package:hive/hive.dart';
import 'package:tendon_loader/settings/settings_model.dart';
import 'package:tendon_loader_lib/tendon_loader_lib.dart';

Future<void> getSettings() async {
  final Box<Map<dynamic, dynamic>> _settingsBox = Hive.box(keyAppSettingsBox);
  late final Map<String, dynamic> _settings;
  if (_settingsBox.containsKey(keyAppSettingsBox)) {
    _settings = Map<String, dynamic>.from(_settingsBox.get(keyAppSettingsBox)!);
    SettingsModel.autoUpload = _settings['_key_auto_upload'] as bool? ?? false;
    SettingsModel.editableExercise = _settings['_key_exercise_editable'] as bool? ?? false;
  } else {
    _settings = <String, dynamic>{
      '_key_auto_upload': SettingsModel.autoUpload = false,
      '_key_exercise_editable': SettingsModel.editableExercise = false,
    };
    await _settingsBox.put(keyAppSettingsBox, _settings);
  }
}

Future<bool> updateSettings() async {
  final Box<Map<dynamic, dynamic>> _settingsBox = Hive.box(keyAppSettingsBox);
  late final Map<String, dynamic> _settings = Map<String, dynamic>.from(_settingsBox.get(keyAppSettingsBox)!);
  _settings['_key_auto_upload'] = SettingsModel.autoUpload;
  _settings['_key_exercise_editable'] = SettingsModel.editableExercise;
  await _settingsBox.put(keyAppSettingsBox, _settings);
  return true;
}
