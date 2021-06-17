import 'package:flutter/material.dart';
import 'package:tendon_loader/modal/chartdata.dart';
import 'package:tendon_loader/modal/prescription.dart';
import 'package:tendon_loader/modal/session_info.dart'; 

@immutable
class DataModel {
  const DataModel({this.dataList, this.sessionInfo, this.prescription, this.mvcValue});

  final double? mvcValue;
  final List<ChartData >? dataList;
  final SessionInfo? sessionInfo;
  final Prescription? prescription;
}
