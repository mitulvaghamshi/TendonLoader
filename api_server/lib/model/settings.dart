import 'package:api_server/sql/settings_table.dart';

class const Settings._({
  required final int? id,
  required final bool darkMode,
  required final bool autoUpload,
  required final bool editablePrescription,
  required final double graphScale,
  required final int? userId,
  required final int? prescriptionId,
}) {
  factory empty() => const ._(
    id: null,
    darkMode: false,
    autoUpload: false,
    editablePrescription: true,
    graphScale: 30,
    userId: null,
    prescriptionId: null,
  );

  factory fromJson(Object? json) {
    if (json case {
      SettingsTable.kId: final int id,
      SettingsTable.kUserId: final int? userId,
      SettingsTable.kPrescriptionId: final int? prescriptionId,
      SettingsTable.kDarkMode: final int darkMode,
      SettingsTable.kAutoUpload: final int autoUpload,
      SettingsTable.kEditablePrescription: final int editablePrescription,
      SettingsTable.kGraphScale: final num graphScale,
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
    throw Exception('[$Settings]: ${StackTrace.current}');
  }
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
