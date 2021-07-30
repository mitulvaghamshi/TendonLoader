import 'package:hive/hive.dart';
import 'package:tendon_loader/modal/prescription.dart';

part 'settings_state.g.dart';

@HiveType(typeId: 5)
class SettingsState extends HiveObject {
  SettingsState({
    this.autoUpload = true,
    this.graphSize = 30,
    this.customPrescriptions = true,
    this.lastDuration,
    this.lastPrescriptions,
  });

  @HiveField(0)
  bool? autoUpload;
  @HiveField(1)
  double? graphSize;
  @HiveField(2)
  bool? customPrescriptions;
  @HiveField(3)
  int? lastDuration;
  @HiveField(4)
  Prescription? lastPrescriptions;
}
