import 'package:flutter/material.dart';

// Datetime format
const String keyDateTimeFormat = 'y-MM-dd hh:mm:ss a';

// Display sizes for web layout.
const Size sizeWideScreen = Size(1440, 410);
const Size sizeMediumScreen = Size(1080, 410);
const Size sizeSmallScreen = Size(720, 410);
const Size sizeTinyScreen = Size(320, 410);

// Database fields, for (x,y) coordinate.
const String keyChartX = 'time';
const String keyChartY = 'load';

// Firestore root collection.
const String keyBase = 'TendonLoader';
const String keyExports = 'exports';

// Hive boxes for local app and user data storage.
const String keyDarkModeBox = 'box_dark_mode';
const String keyExportBox = 'box_user_exports';
const String keyUserStateBox = 'box_user_state';
const String keySettingsStateBox = 'box_settings_state';

// Exercise and MVC session data fields.
const String keySets = 'sets';
const String keyReps = 'reps';
const String keySetRest = 'setRest';
const String keyHoldTime = 'holdTime';
const String keyRestTime = 'restTime';
const String keyTargetLoad = 'targetLoad';
const String keyMvcDuration = 'mvcDuration';

// User (exercise/mvc) session data fields.
const String keyIsAdmin = 'isAdmin';
const String keyUserId = 'userId';
const String keyMvcValue = 'mvcValue';
const String keyPainScore = 'painScore';
const String keyIsTolerable = 'isTolerable';
const String keyTimeStamp = 'timeStamp';
const String keyExportData = 'exportData';
const String keyIsComplate = 'isComplate';
const String keyProgressorId = 'progressorId';
const String keyPrescription = 'prescription';

// local image assets.
const String imgRoot = 'assets/images/';
const String imgAppLogo = imgRoot + 'app_logo.svg';
const String imgEnableDevice = imgRoot + 'enable_device.png';
const String imgEnableLocation = imgRoot + 'enable_location.png';
const String imgEnableBluetooth = imgRoot + 'enable_bluetooth.png';

// Progressor response code. Match this code with data
// to check the type of data received.
const int resCommandResponse = 0;
const int resWeightMeasurement = 1;
const int resRFDPeak = 2;
const int resRFDPeakSeries = 3;
const int resLowPowerWarning = 4;

// Progressor instruction codes. device can return a one time
// or streamed responce, use this codes to check type of response.
const int cmdTareScale = 100;
const int cmdStartWeightMeas = 101;
const int cmdStopWeightMeas = 102;
const int cmdStartPeakRFDMeasurement = 103;
const int cmdStartPeakRFDSeriesMeasurement = 104;
const int cmdAddCalibrationPoint = 105;
const int cmdSaveCalibration = 106;
const int cmdGetAppVersion = 107; // one time
const int cmdGetErrorInformation = 108; // one time
const int cmdClearErrorInformation = 109;
const int cmdEnterSleep = 110;
const int cmdGetBatteryVoltage = 111; // one time

// Service UUID, a main service provides the base connction with receiver.
const String uuidService = '7e4e1701-1ea6-40c9-9dcc-13d34ffead57';

// Control UUID, control instructions can be issued to this uuid.
const String uuidControl = '7e4e1703-1ea6-40c9-9dcc-13d34ffead57';

// Data UUID, progressor can send stream of data over this uuid.
// Subscribe to this uuid to retrieve a stream of encoded data.
// Data requires conversion to specific format before the actual use.
const String uuidData = '7e4e1702-1ea6-40c9-9dcc-13d34ffead57';

// Ask user to power on the Progressor.
const String descEnableDevice =
    '\nActivate your device by pressing the button, then press scan to find the device\n';

// Ask user to tare the Progressor before use. With time, due to mechanical
// design, progressor may record and return data even when its idle. So,
// zero-ing (taring) is required for accurate measurements.
const String descTareProgressor = '\nPlease tare your progressor before use\n';

// Ask user to turn on Bluetooth.
const String descEnableBluetooth =
    '\nThis app needs Bluetooth to communicate with your Progressor.\nPlease enable Bluetooth on your device\n';

// Inform user that location is required to locate the progressor.
const String descLocationLine1 =
    '\nScanning for the Progressor requires location services. '
    'We\'re only using this permission to scan for your Progressor';

// Assure user that no physical location is collected and stored.
const String descLocationLine3 =
    '\nWe\'ll never collect your physical location\n';

// If there is no new MVC Test available to perform.
const String descNoMvcAvailable = 'No MVC test available, please contact your '
    'clinician or turn on custom prescriptions in settings.';

// If there is no new Exercise available to perform.
const String descNoExerciseAvailable =
    'No exercise prescription available, please '
    'contact your clinician or turn on '
    'custom prescriptions in settings.';

// Regex pattern for emain address (do not modify). Source: dart-docs.
const String emailRegEx =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

// Firebase Authentication errors.
// This maps the firebase error codes to simple descriptions.
final Map<String, String> firebaseErrors = <String, String>{
  'wrong-password': 'Invalid password.',
  'invalid-email': 'Invalid email address.',
  'weak-password': 'The password is too weak.',
  'user-disabled': 'This account is disabled.',
  'user-not-found': 'No account found for this email address.',
  'email-already-in-use': 'The account already exists for that email.',
  'operation-not-allowed': 'You are no allowed the access (or disabled).',
};
