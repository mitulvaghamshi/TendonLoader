/// Author: Mitul Vaghamshi
/// Email: mitulvaghmashi@gmail.com

import 'package:hive/hive.dart';
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

  void toggle(bool isCustom, Prescription pre) {
    customPrescriptions = isCustom;
    if (!customPrescriptions!) {
      if (pre.targetLoad > 0) {
        prescription = pre;
      }
      if (pre.mvcDuration > 0) {
        mvcDuration = pre.mvcDuration;
      }
    }
  }
}
