import 'dart:convert';

class ChartData {
  ChartData({this.time = 0, this.load = 0});

  ChartData.fromString(String rawString) {
    final Map<String, dynamic> map = jsonDecode(rawString) as Map<String, dynamic>;
    time = map['time'] as double;
    load = map['load'] as double;
  }

  double time;
  double load;

  @override
  String toString() => '$time,$load';
}
