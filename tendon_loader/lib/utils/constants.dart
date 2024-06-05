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

  static const appLogoSvgNs =
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 400">';

  static const appLogoSvgData = '''
m212 35-2 8c-3 13-8 19-19 22-9 2-9 2-10 5 0 2 1 3 7 5 14 3 19 8 22 24 2 7 8 10 8 3 0-14 9-25 24-28 7-1 8-7 0-8-14-2-21-9-23-24-1-6-4-9-7-7m10 30 5 4c2 1 2 2 0 2-3 2-8 6-10 10-3 5-3 5-5 1-1-3-7-9-10-10s-3-2 1-4l10-10 1-4 2 4 6 7M91 89c-3 3 0 7 28 30 35 30 46 35 108 52l42 12c37 13 43 13 59 8 14-5 16-4 11 8-9 17-25 26-46 25-51-3-59-1-91 20-14 9-17 10-26 11-13 0-18-4-33-30-18-33-21-36-68-64-22-13-25-14-24-8 0 3 4 6 38 26 25 15 31 21 42 40l11 19c17 29 33 32 65 12 28-18 40-21 78-19 21 1 25 1 37-5 15-7 27-24 27-37 0-10-5-12-22-6-15 5-20 5-55-7l-41-12c-71-19-77-23-129-70-7-6-9-7-11-5m179 17-2 2c-2 12-4 15-11 17l-6 1-1 3 1 3 5 1c3 1 6 2 7 4 2 2 3 3 5 11 1 4 5 5 6 1l5-12 11-5c5 0 3-6-3-7-8-2-10-5-12-16-1-2-3-3-5-3m4 20 3 3-3 3-3 3-3-3-3-3 3-3 3-3 3 3m-119 71c-2 3 0 7 6 13 11 9 34 10 30 1-1-2-2-2-8-2-11 0-17-3-21-10-2-3-5-4-7-2m92 85a1118 1118 0 0 0-79 23c-10 5-11 20-1 26 5 3 7 3 33-1 23-3 24-3 25-1 2 2 6 0 6-3s-4-6-7-6l-26 3c-28 4-30 4-30-4 0-6 3-7 15-11l40-11c44-12 41-13 79 16 6 4 8 4 9 2 2-3 1-5-8-12l-18-12a42 42 0 0 0-38-9m-151 2c-8 4-11 15-6 22 2 4 3 5 65 48 19 14 20 14 68 5 41-8 41-8 48-3s14 3 9-3c-11-10-12-10-58-2-50 9-44 10-72-10l-36-25c-20-15-22-18-16-24 5-4 4-4 30 12l20 12c4 0 5-6 2-8-43-26-46-28-54-24''';
}
