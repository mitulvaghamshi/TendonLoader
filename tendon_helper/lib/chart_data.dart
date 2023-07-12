import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tendon_loader/utils.dart';

@immutable
class ChartData {
  const ChartData({this.time = 0, this.load = 0});

  factory ChartData.fromJson(String data) =>
      ChartData.fromMap(jsonDecode(data) as Map<String, dynamic>);

  factory ChartData.fromMap(Map<String, dynamic> map) => ChartData(
        time: map[keyChartX] as double,
        load: map[keyChartY] as double,
      );

  factory ChartData.fromEntry(Map<String, dynamic> map) {
    final MapEntry<String, dynamic> entry = map.entries.first;
    return ChartData(
      time: double.parse(entry.key),
      load: double.parse(entry.value.toString()),
    );
  }

  final double time;
  final double load;
}
