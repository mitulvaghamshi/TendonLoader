import 'package:flutter/material.dart';

@immutable
class Settings {
  const Settings._({
    required this.id,
    required this.darkMode,
    required this.autoUpload,
    required this.editablePrescription,
    required this.graphScale,
    required this.userId,
    required this.prescriptionId,
  });

  const Settings.empty()
      : id = null,
        darkMode = false,
        autoUpload = false,
        editablePrescription = true,
        graphScale = 30.0,
        userId = null,
        prescriptionId = null;

  factory Settings.fromJson(final map) => ExSettings._parseJson(map);

  final int? id;
  final int? userId;
  final int? prescriptionId;
  final bool darkMode;
  final bool autoUpload;
  final bool editablePrescription;
  final double graphScale;
}

extension ExSettings on Settings {
  ThemeMode get themeMode => darkMode ? ThemeMode.dark : ThemeMode.light;

  Map<String, dynamic> get json => {
        'id': id,
        'userId': userId,
        'prescriptionId': prescriptionId,
        'darkMode': darkMode,
        'autoUpload': autoUpload,
        'editablePrescriprion': editablePrescription,
        'graphScale': graphScale,
      };

  Settings copyWith({
    final int? id,
    final int? userId,
    final int? prescriptionId,
    final bool? darkMode,
    final bool? autoUpload,
    final bool? editablePrescription,
    final double? graphScale,
  }) {
    return Settings._(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      prescriptionId: prescriptionId ?? this.prescriptionId,
      darkMode: darkMode ?? this.darkMode,
      autoUpload: autoUpload ?? this.autoUpload,
      editablePrescription: editablePrescription ?? this.editablePrescription,
      graphScale: graphScale ?? this.graphScale,
    );
  }

  static Settings _parseJson(final map) {
    if (map
        case {
          'id': final int id,
          'userId': final int userId,
          'prescriptionId': final int? prescriptionId,
          'darkMode': final bool darkMode,
          'autoUpload': final bool autoUpload,
          'editablePrescriprion': final bool editablePrescription,
          'graphScale': final num graphScale,
        }) {
      return Settings._(
        id: id,
        userId: userId,
        prescriptionId: prescriptionId,
        darkMode: darkMode,
        autoUpload: autoUpload,
        editablePrescription: editablePrescription,
        graphScale: graphScale.toDouble(),
      );
    }
    throw const FormatException('Invalid JSON');
  }
}
