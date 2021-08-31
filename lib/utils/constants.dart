// datetime
import 'package:flutter/material.dart';

const String keyDateTimeFormat = 'y-MM-dd hh:mm:ss a';

// display sizes
const Size sizeWideScreen = Size(1440, 410);
const Size sizeMediumScreen = Size(1080, 410);
const Size sizeSmallScreen = Size(720, 410);
const Size sizeTinyScreen = Size(320, 410);

// sound clips
const String keyStartClip = 'start.ogg';
const String keyStopClip = 'stop.ogg';

// chart
const String keyChartX = 'time';
const String keyChartY = 'load';

// firestore
const String keyBase = 'TendonLoader';
const String keyExports = 'exports';

// boxes
const String keyDarkModeBox = 'box_dark_mode';
const String keyExportBox = 'box_user_exports';
const String keyUserStateBox = 'box_user_state';
const String keySettingsStateBox = 'box_settings_state';

// prescription
const String keyIsAdmin = 'isAdmin';
const String keySets = 'sets';
const String keyReps = 'reps';
const String keySetRest = 'setRest';
const String keyHoldTime = 'holdTime';
const String keyRestTime = 'restTime';
const String keyTargetLoad = 'targetLoad';
const String keyMvcDuration = 'mvcDuration';

// export
const String keyUserId = 'userId';
const String keyMvcValue = 'mvcValue';
const String keyPainScore = 'painScore';
const String keyIsTolerable = 'isTolerable';
const String keyTimeStamp = 'timeStamp';
const String keyExportData = 'exportData';
const String keyIsComplate = 'isComplate';
const String keyProgressorId = 'progressorId';
const String keyPrescription = 'prescription';

// assets
const String audioRoot = 'assets/audio/';
const String imgRoot = 'assets/images/';
const String imgAppLogo = imgRoot + 'app_logo.svg';
const String imgEnableDevice = imgRoot + 'enable_device.png';
const String imgEnableLocation = imgRoot + 'enable_location.png';
const String imgEnableBluetooth = imgRoot + 'enable_bluetooth.png';

// progressor responses
const int resCommandResponse = 0;
const int resWeightMeasurement = 1;
const int resRFDPeak = 2;
const int resRFDPeakSeries = 3;
const int resLowPowerWarning = 4;

// progressor commands
const int cmdTareScale = 100;
const int cmdStartWeightMeas = 101;
const int cmdStopWeightMeas = 102;
const int cmdStartPeakRFDMeasurement = 103;
const int cmdStartPeakRFDSeriesMeasurement = 104;
const int cmdAddCalibrationPoint = 105;
const int cmdSaveCalibration = 106;
const int cmdGetAppVersion = 107; // CMD RES
const int cmdGetErrorInformation = 108; // CMD RES
const int cmdClearErrorInformation = 109;
const int cmdEnterSleep = 110;
const int cmdGetBatteryVoltage = 111; // CMD RES

// progressor UUIDs
const String uuidService =
    '7e4e1701-1ea6-40c9-9dcc-13d34ffead57'; // main service
const String uuidControl =
    '7e4e1703-1ea6-40c9-9dcc-13d34ffead57'; // send commands
const String uuidData = '7e4e1702-1ea6-40c9-9dcc-13d34ffead57'; // receive data

// long descriptions
const String descEnableDevice =
    '\nActivate your device by pressing the button, '
    'then press scan to find the device\n';

const String descTareProgressor = '\nPlease tare your progressor before use\n';

const String descEnableBluetooth = '\nThis app needs Bluetooth to communicate '
    'with your Progressor.\nPlease '
    'enable Bluetooth on your device\n';

const String descLocationLine1 =
    '\nScanning for the Progressor requires location services. '
    'We\'re only using this permission to scan for your Progressor';

const String descLocationLine3 =
    '\nWe\'ll never collect your physical location\n';

const String descNoMvcAvailable = 'No MVC test available, please contact your '
    'clinician or turn on custom prescriptions in settings.';

const String descNoExerciseAvailable =
    'No exercise prescription available, please '
    'contact your clinician or turn on '
    'custom prescriptions in settings.';

// email regex pattern (do not modify at all)
const String emailRegEx =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

final Map<String, String> firebaseErrors = <String, String>{
  'email-already-in-use': 'The account already exists for that email.',
  'invalid-email': 'Invalid email.',
  'weak-password': 'The password is too weak.',
  'wrong-password': 'Invalid password.',
  'user-not-found': 'No user found for that email. '
      'Make sure you enter right credentials.',
  'user-disabled': 'This account is disabled.',
  'operation-not-allowed': 'This account is disabled.',
};
