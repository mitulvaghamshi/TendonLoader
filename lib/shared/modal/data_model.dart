import 'package:flutter/material.dart';
import 'package:tendon_loader/shared/modal/chartdata.dart';
import 'package:tendon_loader/shared/modal/prescription.dart';
import 'package:tendon_loader/shared/modal/session_info.dart';

@immutable
class DataModel {
  const DataModel({this.dataList, this.sessionInfo, this.prescription});

  final List<ChartData>? dataList;
  final SessionInfo? sessionInfo;
  final Prescription? prescription;
}
