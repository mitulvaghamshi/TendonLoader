class ChartData {
  const ChartData({this.time = 0, this.load = 0});

  factory ChartData.fromPair(String data) {
    final items = data.split(':');
    return .new(time: .parse(items[0]), load: .parse(items[1]));
  }

  final double time;
  final double load;
}

extension ChartDataExt on ChartData {
  String get pair => '$time:$load';

  ChartData copyWith({double? time, double? load}) {
    return .new(time: time ?? this.time, load: load ?? this.load);
  }
}
