import 'dart:convert';

import 'package:tendon_loader/shared/constants.dart';

class ChartData {
  ChartData({this.time = 0, this.load = 0});

  ChartData.fromJson(String data) {
    final Map<String, dynamic> map = jsonDecode(data) as Map<String, dynamic>;
    time = map[Keys.KEY_CHART_Y] as double;
    load = map[Keys.KEY_CHART_X] as double;
  }

  ChartData.fromMap(Map<String, dynamic> item) {
    time = item[Keys.KEY_CHART_Y] as double;
    load = item[Keys.KEY_CHART_X] as double;
  }

  double time;
  double load;

  @override
  String toString() => '$time,$load';
}
