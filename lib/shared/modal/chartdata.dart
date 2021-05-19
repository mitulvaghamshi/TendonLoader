import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tendon_loader/shared/constants.dart';

@immutable
class ChartData {
  const ChartData({this.time = 0, this.load = 0});

  factory ChartData.fromJson(String data) => ChartData.fromMap(jsonDecode(data) as Map<String, dynamic>);

  factory ChartData.fromMap(Map<String, dynamic> map) =>
      ChartData(time: map[Keys.KEY_CHART_Y] as double, load: map[Keys.KEY_CHART_X] as double);

  final double time;
  final double load;

  @override
  String toString() => '$time,$load';
}
