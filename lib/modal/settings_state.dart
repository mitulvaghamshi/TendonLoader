import 'package:hive/hive.dart';

part 'settings_state.g.dart';

@HiveType(typeId: 5)
class SettingsState extends HiveObject {
  SettingsState({
    this.autoUpload = false,
    this.graphSize = 30,
    this.customPrescriptions = true,
  });

  @HiveField(0)
  bool? autoUpload;
  @HiveField(1)
  double? graphSize;
  @HiveField(2)
  bool? customPrescriptions;
}
