import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tendon_loader/constants/constants.dart';
 
@immutable
class SessionInfo {
  const SessionInfo({
    required this.isMVC,
    required this.userId,
    required this.dateTime,
    required this.isComplate,
    required this.progressorId,
  });

  final bool isMVC;
  final String userId;
  final bool isComplate;
  final DateTime dateTime;
  final String progressorId;

  String get tileName => DateFormat(keyDateTimeFormat).format(dateTime);
  String get fileName =>
      tileName.replaceAll(RegExp(r'[\s:]'), '-') + '_${userId}_${isMVC ? 'MVCTest' : 'Exercise'}_$progressorId.xlsx';
}
