import 'package:flutter/material.dart';

class Styles {
  static const EdgeInsets tilePadding =
      EdgeInsets.symmetric(horizontal: 16, vertical: 5);

  static const TextStyle numPickerText =
      TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold);

  static const TextStyle titleStyle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

  static const TextStyle headerLabel =
      TextStyle(color: Color(0xff000000), fontWeight: FontWeight.bold);

  static const TextStyle headerText = TextStyle(
      color: Color(0xff000000), fontWeight: FontWeight.bold, fontSize: 40);

  static const boldWhite =
      TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
}

class DataKeys {
  // Collections
  static const String rootCollection = 'TendonLoader';
  static const String exportsCollection = 'exports';

  // User doc field
  static const String isAdmin = 'isAdmin';

  // Export data fields
  static const String userId = 'userId';
  static const String mvcValue = 'mvcValue';
  static const String painScore = 'painScore';
  static const String isTolerable = 'isTolerable';
  static const String timeStamp = 'timeStamp';
  static const String isComplate = 'isComplate';
  static const String progressorId = 'progressorId';
  static const String exportData = 'exportData';
  static const String prescription = 'prescription';

  // Exercise and MVC session data fields
  static const String sets = 'sets';
  static const String reps = 'reps';
  static const String setRest = 'setRest';
  static const String holdTime = 'holdTime';
  static const String restTime = 'restTime';
  static const String targetLoad = 'targetLoad';
  static const String mvcDuration = 'mvcDuration';

  // Chart data fields (X,Y)
  static const String keyChartX = 'time';
  static const String keyChartY = 'load';
}

class SettingsKeys {
  // User temp data and app settings keys
  static const String darkMode = 'darkMode';
  static const String autoUpload = 'autoUpload';
  static const String graphScale = 'graphScale';
  static const String customPrescription = 'customPrescription';
  static const String lastPrescription = 'lastPrescription';
}

class Images {
  // Asset image resources
  static const String appLogo = 'assets/app_logo.svg';
  static const String enableDevice = 'assets/enable_device.webp';
  static const String enableLocation = 'assets/enable_location.webp';
  static const String enableBluetooth = 'assets/enable_bluetooth.webp';
}

class Responses {
  // Progressor response code (first 4 byte = first list element)
  static const int commandResponse = 0;
  static const int weightMeasurement = 1;
  static const int rfdPeak = 2;
  static const int rfdPeakSeries = 3;
  static const int lowPowerWarning = 4;
}

class Commands {
  // Progressor instruction codes
  // device can return a one time or streamed response
  static const int tareScale = 100;
  static const int startWeightMeas = 101;
  static const int stopWeightMeas = 102;
  static const int startPeakRFDMeasurement = 103;
  static const int startPeakRFDSeriesMeasurement = 104;
  static const int addCalibrationPoint = 105;
  static const int saveCalibration = 106;
  static const int getAppVersion = 107; // one time
  static const int getErrorInformation = 108; // one time
  static const int clearErrorInformation = 109;
  static const int enterSleep = 110;
  static const int getBatteryVoltage = 111; // one time
}

class DeviceUUID {
  // Service UUID, a main service provides the base connection with receiver
  static const String service = '7e4e1701-1ea6-40c9-9dcc-13d34ffead57';

  // Control UUID, control instructions can be issued to this uuid
  static const String controller = '7e4e1703-1ea6-40c9-9dcc-13d34ffead57';

  // Data UUID, Progressor can send stream of data over this uuid
  // Subscribe to this uuid to retrieve a stream of encoded data
  static const String data = '7e4e1702-1ea6-40c9-9dcc-13d34ffead57';
}

class Strings {
  // Ask user to power on the Progressor.
  static const String enableDevice =
      '\nActivate your device by pressing the button, '
      'then press scan to find the device\n';

  // Ask user to turn on Bluetooth.
  static const String enableBluetooth =
      '\nThis app needs Bluetooth to communicate with your Progressor.'
      '\nPlease enable Bluetooth on your device\n';

  // Inform user that location is required to locate the Progressor.
  static const String locationLine1 =
      '\nScanning for the Progressor requires location services. '
      "We're only using this permission to scan for your Progressor";

  // Assure user that no physical location is collected and stored.
  static const String locationLine2 =
      "\nWe'll never collect your physical location\n";

  // If there is no new MVC Test available to perform.
  static const String noMVCAvailable =
      'No MVC test available, please contact your '
      'clinician or turn on custom prescriptions in settings.';

  // If there is no new Exercise available to perform.
  static const String noExerciseAvailable =
      'No exercise prescription available, please '
      'contact your clinician or turn on '
      'custom prescriptions in settings.';

  // Ask user to tare the Progressor before use. With time, due to mechanical
  // design, Progressor may record and return data even when its idle. So,
  // zero-ing (taring) is required for accurate measurements.
  static const String tareProgressor =
      '\nPlease tare your Progressor before use\n';
}
