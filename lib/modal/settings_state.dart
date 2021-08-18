import 'package:hive/hive.dart';
import 'package:tendon_loader/modal/patient.dart';
import 'package:tendon_loader/modal/prescription.dart';

part 'settings_state.g.dart';

@HiveType(typeId: 5)
class SettingsState extends HiveObject {
  SettingsState({
    this.autoUpload = true,
    this.graphSize = 30,
    this.customPrescriptions = true,
    this.mvcDuration,
    this.prescription,
  });

  @HiveField(0)
  bool? autoUpload;
  @HiveField(1)
  double? graphSize;
  @HiveField(2)
  bool? customPrescriptions;
  @HiveField(3)
  int? mvcDuration;
  @HiveField(4)
  Prescription? prescription;

  void toggleCustom(bool value, Patient user) {
    customPrescriptions = value;
    if (!customPrescriptions!) {
      if (user.prescription!.targetLoad > 0) {
        prescription = user.prescription;
      }
      if (user.prescription!.mvcDuration > 0) {
        mvcDuration = user.prescription!.mvcDuration;
      }
    }
  }
}
