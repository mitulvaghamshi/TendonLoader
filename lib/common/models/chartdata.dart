import 'package:hive/hive.dart';

part 'chartdata.g.dart';

@HiveType(typeId: 4)
class ChartData extends HiveObject {
  ChartData({this.time = 0, this.load = 0});

  factory ChartData.fromEntry(Map<String, dynamic> map) {
    final MapEntry<String, dynamic> entry = map.entries.first;
    return ChartData(
      time: double.parse(entry.key),
      load: double.parse(entry.value.toString()),
    );
  }

  @HiveField(0)
  final double time;
  @HiveField(1)
  final double load;
}
