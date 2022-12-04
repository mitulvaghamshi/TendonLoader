import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:tendon_loader/common/models/export.dart';
import 'package:tendon_loader/common/models/prescription.dart';
import 'package:tendon_loader/screens/settings/models/app_scope.dart';
import 'package:tendon_loader/screens/settings/models/settings.dart';

class AppState {
  AppState();

  static AppState of(BuildContext context) {
    final AppScope? scope =
        context.dependOnInheritedWidgetOfExactType<AppScope>();
    if (scope == null) throw 'No RouteState in scope!';
    return scope.data;
  }

  Future<void> initWith(String userId) async {
    _exportBox = await Hive.openBox<Export>('$userId-exports.dat');
    final Box<Settings> settingsBox =
        await Hive.openBox<Settings>('$userId-settings.dat');
    _settings = settingsBox.get(userId, defaultValue: Settings.empty())!;
    if (!_settings.isInBox) await settingsBox.put(userId, _settings);
    _settings.userId = userId;
    _settings.save();
  }

  // Start: export box
  late final Box<Export> _exportBox;

  int getLocalExportLength() => _exportBox.length;

  Future<Export> getExportFor(String key) async {
    if (!_exportBox.containsKey(key)) {
      throw 'No Export found for key: [$key]';
    }
    final Export? export = _exportBox.get(key);
    if (export == null) {
      await _exportBox.delete(key);
      throw 'Export is null, Removing...';
    }
    return export;
  }

  Future<void> addToBox(Export export) async {
    if (!export.isInBox) {
      _exportBox.put(export.fileName, export);
    }
  }

  Future<int> uploadExports() async {
    final bool isEnabled = await loc.isNetworkEnabled();
    if (!isEnabled) return -1;
    int count = 0;
    for (final Export export in _exportBox.values) {
      if (await export.upload()) count++;
    }
    return count;
  }
  // End: export box

  // ExportList: item tap
  Export? _selectedExport;

  Export getSelectedExport() {
    if (_selectedExport == null) throw 'Selection is in invalid state';
    return _selectedExport!;
  }

  void setSelectedExport(Export export) => _selectedExport = export;
  // End ExportList: item tap

  // Start: Settings
  late final Settings _settings;

  String getCurrentUserId() {
    final String? userId = _settings.userId;
    if (userId == null) throw 'No user found!';
    return userId;
  }

  bool isDarkMode() {
    try {
      return _settings.darkMode;
    } catch (e) {
      return true;
    }
  }

  bool isAutoUpload() => _settings.autoUpload;
  bool isCustomPrescriptions() => _settings.customPrescriptions;
  double getGraphScale() => _settings.graphScale;
  Prescription getLastPrescription() => _settings.prescription;
  int getLastMvcDuration() => _settings.prescription.mvcDuration;

  void settings(void Function(Settings settings) callback) {
    callback(_settings);
    _settings.save();
  }
  // End: Settings
}
