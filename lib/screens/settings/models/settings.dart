import 'package:hive/hive.dart';
import 'package:tendon_loader/common/models/prescription.dart';

part 'settings.g.dart';

@HiveType(typeId: 1)
class Settings extends HiveObject {
  Settings({
    required this.darkMode,
    required this.autoUpload,
    required this.customPrescriptions,
    required this.graphScale,
    required this.userId,
    required this.prescription,
  });

  factory Settings.empty() {
    return Settings(
      darkMode: true,
      autoUpload: false,
      customPrescriptions: true,
      graphScale: 30.0,
      userId: null,
      prescription: Prescription.empty(),
    );
  }

  @HiveField(0)
  bool darkMode;
  @HiveField(1)
  bool autoUpload;
  @HiveField(2)
  bool customPrescriptions;
  @HiveField(3)
  double graphScale;
  @HiveField(4)
  String? userId;
  @HiveField(5)
  Prescription prescription;

  Settings copyWith({
    bool? darkMode,
    bool? autoUpload,
    bool? customPrescriptions,
    double? graphScale,
    String? userId,
    Prescription? prescription,
  }) {
    return Settings(
      darkMode: darkMode ?? this.darkMode,
      autoUpload: autoUpload ?? this.autoUpload,
      customPrescriptions: customPrescriptions ?? this.customPrescriptions,
      graphScale: graphScale ?? this.graphScale,
      userId: userId ?? this.userId,
      prescription: prescription ?? this.prescription,
    );
  }
}
