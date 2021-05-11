import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tendon_loader/app/handler/bluetooth_handler.dart';
import 'package:tendon_loader/shared/constants.dart';

class SessionInfo {
  SessionInfo({this.userId, this.exportType, bool dataStatus, DateTime dateTime})
      : progressorId = Bluetooth.deviceName,
        dataStatus = dataStatus ? 'Complete' : 'Incomplete',
        exportDate = DateFormat(Keys.KEY_DATE_FORMAT).format(dateTime),
        exportTime = DateFormat(Keys.KEY_TIME_FORMAT).format(dateTime);

  SessionInfo.fromMap(Map<dynamic, dynamic> map) {
    userId = map[Keys.KEY_USERNAME].toString();
    exportType = map[Keys.KEY_EXPORT_TYPE].toString();
    dataStatus = map[Keys.KEY_DATA_STATUS].toString();
    exportDate = map[Keys.KEY_EXPORT_DATE].toString();
    exportTime = map[Keys.KEY_EXPORT_TIME].toString();
    progressorId = map[Keys.KEY_PROGRESSOR_ID].toString();
  }

  String userId;
  String exportType;
  String dataStatus;
  String exportDate;
  String exportTime;
  String progressorId;

  String get typeAbbr => exportType.substring(0, 3).toUpperCase();
  Color get color => exportType.contains('MVC') ? Colors.orange : Colors.green;
  String get fileName => '${exportDate}_${exportTime.replaceAll(RegExp(r'[\s:]'), '-')}_${userId}_$exportType.xlsx';

  Map<String, String> toMap() {
    return <String, String>{
      Keys.KEY_USERNAME: userId,
      Keys.KEY_EXPORT_TYPE: exportType,
      Keys.KEY_DATA_STATUS: dataStatus,
      Keys.KEY_EXPORT_DATE: exportDate,
      Keys.KEY_EXPORT_TIME: exportTime,
      Keys.KEY_PROGRESSOR_ID: progressorId,
    };
  }

  DataTable toTable() {
    return DataTable(
      columnSpacing: 20,
      dataRowHeight: 40,
      horizontalMargin: 10,
      headingRowHeight: 40,
      headingRowColor: MaterialStateProperty.all<Color>(Colors.grey.withOpacity(0.3)),
      columns: const <DataColumn>[
        DataColumn(label: Text('Date')),
        DataColumn(label: Text('Time')),
        DataColumn(label: Text('Export Type')),
        DataColumn(label: Text('Export Status')),
        DataColumn(label: Text('Device ID')),
        DataColumn(label: Text('User ID')),
      ],
      rows: <DataRow>[
        DataRow(cells: <DataCell>[
          DataCell(Text(exportDate)),
          DataCell(Text(exportTime)),
          DataCell(Text(exportType)),
          DataCell(Text(dataStatus)),
          DataCell(Text(progressorId)),
          DataCell(Text(userId)),
        ])
      ],
    );
  }
}
