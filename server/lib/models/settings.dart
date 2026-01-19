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
      'id': int id,
      'user_id': int? userId,
      'prescription_id': int? prescriptionId,
      'dark_mode': int darkMode,
      'auto_upload': int autoUpload,
      'editable_prescription': int editablePrescription,
      'graph_scale': num graphScale,
    }) {
      return Settings._(
        id: id,
        userId: userId,
        prescriptionId: prescriptionId,
        darkMode: darkMode == 1,
        autoUpload: autoUpload == 1,
        editablePrescription: editablePrescription == 1,
        graphScale: graphScale.toDouble(),
      );
    }
    throw FormatException('[Settings]: Invalid JSON data: $json');
  }

  final int? id;
  final int? userId;
  final int? prescriptionId;
  final bool darkMode;
  final bool autoUpload;
  final bool editablePrescription;
  final double graphScale;
}

extension Utils on Settings {
  Map<String, dynamic> get map => {
    'id': id,
    'user_id': userId,
    'prescription_id': prescriptionId,
    'dark_mode': darkMode,
    'auto_upload': autoUpload,
    'editable_prescription': editablePrescription,
    'graph_scale': graphScale,
  };

  Settings copyWith({
    int? userId,
    int? prescriptionId,
    bool? darkMode,
    bool? autoUpload,
    bool? editablePrescription,
    double? graphScale,
  }) {
    return Settings._(
      id: id,
      userId: userId ?? this.userId,
      prescriptionId: prescriptionId ?? this.prescriptionId,
      darkMode: darkMode ?? this.darkMode,
      autoUpload: autoUpload ?? this.autoUpload,
      editablePrescription: editablePrescription ?? this.editablePrescription,
      graphScale: graphScale ?? this.graphScale,
    );
  }
}
