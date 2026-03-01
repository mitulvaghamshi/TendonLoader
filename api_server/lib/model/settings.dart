import 'package:api_server/sql/settings_table.dart';

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

  factory Settings.fromJson(Object? json) {
    if (json case {
      SettingsTable.kId: int id,
      SettingsTable.kUserId: int? userId,
      SettingsTable.kPrescriptionId: int? prescriptionId,
      SettingsTable.kDarkMode: int darkMode,
      SettingsTable.kAutoUpload: int autoUpload,
      SettingsTable.kEditablePrescription: int editablePrescription,
      SettingsTable.kGraphScale: num graphScale,
    }) {
      return ._(
        id: id,
        userId: userId,
        prescriptionId: prescriptionId,
        darkMode: darkMode == 1,
        autoUpload: autoUpload == 1,
        editablePrescription: editablePrescription == 1,
        graphScale: graphScale.toDouble(),
      );
    }

    throw FormatException('[$Settings]: Invalid JSON data: $json');
  }

  final int? id;
  final int? userId;
  final int? prescriptionId;
  final bool darkMode;
  final bool autoUpload;
  final bool editablePrescription;
  final double graphScale;
}

extension SettingsExt on Settings {
  Map<String, dynamic> get map => {
    SettingsTable.kId: id,
    SettingsTable.kUserId: userId,
    SettingsTable.kPrescriptionId: prescriptionId,
    SettingsTable.kDarkMode: darkMode,
    SettingsTable.kAutoUpload: autoUpload,
    SettingsTable.kEditablePrescription: editablePrescription,
    SettingsTable.kGraphScale: graphScale,
  };

  Settings copyWith({
    int? userId,
    int? prescriptionId,
    bool? darkMode,
    bool? autoUpload,
    bool? editablePrescription,
    double? graphScale,
  }) => ._(
    id: id,
    userId: userId ?? this.userId,
    prescriptionId: prescriptionId ?? this.prescriptionId,
    darkMode: darkMode ?? this.darkMode,
    autoUpload: autoUpload ?? this.autoUpload,
    editablePrescription: editablePrescription ?? this.editablePrescription,
    graphScale: graphScale ?? this.graphScale,
  );
}
