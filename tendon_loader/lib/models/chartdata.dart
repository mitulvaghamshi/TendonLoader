import 'package:flutter/foundation.dart';

@immutable
class ChartData {
  const ChartData({this.time = 0, this.load = 0});

  factory ChartData.fromPair(final data) => ExChartData._parseJson(data);

  final double time;
  final double load;
}

extension ExChartData on ChartData {
  String get pair => '$time:$load';

  ChartData copyWith({final double? time, final double? load}) {
    return ChartData(time: time ?? this.time, load: load ?? this.load);
  }

  static ChartData _parseJson(final String data) {
    final items = data.split(':');
    return ChartData(
      time: double.parse(items[0]),
      load: double.parse(items[1]),
    );
  }
}
