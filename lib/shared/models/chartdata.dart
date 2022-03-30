import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:tendon_loader/shared/utils/constants.dart';

part 'chartdata.g.dart';

@HiveType(typeId: 1)
class ChartData extends HiveObject {
  ChartData({this.time = 0, this.load = 0});

  ChartData.fromJson(String data)
      : this.fromMap(jsonDecode(data) as Map<String, dynamic>);

  ChartData.fromMap(Map<String, dynamic> map)
      : this(
          time: map[keyChartX] as double,
          load: map[keyChartY] as double,
        );

  ChartData.fromEntry(MapEntry<String, dynamic> entry)
      : this(
          time: double.parse(entry.key),
          load: double.parse(entry.value.toString()),
        );

  Map<String, double> toMap() => <String, double>{'$time': load};

  @HiveField(0)
  final double time;
  @HiveField(1)
  final double load;
}
