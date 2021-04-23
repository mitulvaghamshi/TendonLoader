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
}
