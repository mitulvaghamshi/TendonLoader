/// Author: Mitul Vaghamshi
/// Email: mitulvaghmashi@gmail.com

import 'package:flutter/material.dart';

/// Datetime format
const String keyDateTimeFormat = 'y-MM-dd hh:mm:ss a';

/// Display sizes for responsive web layout.
const Size sizeWideScreen = Size(1440, 410);
const Size sizeMediumScreen = Size(1080, 410);
const Size sizeSmallScreen = Size(720, 410);
const Size sizeTinyScreen = Size(320, 410);

/// Sound clip names.
const String keyStartClip = 'start.ogg';
const String keyStopClip = 'stop.ogg';

/// Database field names, X, Y coordinate.
const String keyChartX = 'time';
const String keyChartY = 'load';

/// Firestore collection names.  
const String keyBase = 'TendonLoader';
const String keyExports = 'exports';

/// Box names (keys) to be used by Hive to store app data.
const String keyDarkModeBox = 'box_dark_mode';
const String keyExportBox = 'box_user_exports';
const String keyUserStateBox = 'box_user_state';
const String keySettingsStateBox = 'box_settings_state';

/// Names (keys) of fields for the exercise and mvc session and firestore.
const String keySets = 'sets';
const String keyReps = 'reps';
const String keySetRest = 'setRest';
const String keyHoldTime = 'holdTime';
const String keyRestTime = 'restTime';
const String keyTargetLoad = 'targetLoad';
const String keyMvcDuration = 'mvcDuration';

/// Names (keys) of fields for a session data performed by the patient.
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

/// Names of the local assets and it's path used by the app and the web.
const String audioRoot = 'assets/audio/';
const String imgRoot = 'assets/images/';
const String imgAppLogo = imgRoot + 'app_logo.svg';
const String imgEnableDevice = imgRoot + 'enable_device.png';
const String imgEnableLocation = imgRoot + 'enable_location.png';
const String imgEnableBluetooth = imgRoot + 'enable_bluetooth.png';

/// Data response codes of Progressor.
/// Match this code with data to determine the type of data received.
const int resCommandResponse = 0;
const int resWeightMeasurement = 1;
const int resRFDPeak = 2;
const int resRFDPeakSeries = 3;
const int resLowPowerWarning = 4;

/// Commands to be issued on the Progressor to perform respective action.
/// 'CMD RES' below are the commands that returns one time reponse,
/// Use response codes to determine type of data returned.
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

/// UUIDs used by the Progressor for diferent services.

/// The [Service] uuid is the main service that used by the app
/// to connect and communicate throughout the connection.
const String uuidService =
    '7e4e1701-1ea6-40c9-9dcc-13d34ffead57'; // main service

/// The [Control] uuid is the service listening for commands issued by the 
/// connected application, all control commands are send to this uuid.
const String uuidControl =
    '7e4e1703-1ea6-40c9-9dcc-13d34ffead57'; // send commands

/// The [Data] uuid where the Progressor can transmit it's measured data,
/// An app must subscribe to this uuid to retrieve a stream of data.
/// Refer to project resources to learn more about data and how convert it 
/// into a meaningful information.
const String uuidData = '7e4e1702-1ea6-40c9-9dcc-13d34ffead57'; // receive data

/// Text descriptions used by the app to guide user to take certain actions.

/// Tell user to power on the Progressor.
const String descEnableDevice =
    '\nActivate your device by pressing the button, '
    'then press scan to find the device\n';

/// Ask user to tare (zero-ing) the Progressor before use.
const String descTareProgressor = '\nPlease tare your progressor before use\n';

/// Tell user to turn on Bluetooth.
const String descEnableBluetooth = '\nThis app needs Bluetooth to communicate '
    'with your Progressor.\nPlease '
    'enable Bluetooth on your device\n';

/// Tell why location is required.
const String descLocationLine1 =
    '\nScanning for the Progressor requires location services. '
    'We\'re only using this permission to scan for your Progressor';

/// User privacy statement.
const String descLocationLine3 =
    '\nWe\'ll never collect your physical location\n';

/// When there is no new MVC Test created by the Clinician for the user.
const String descNoMvcAvailable = 'No MVC test available, please contact your '
    'clinician or turn on custom prescriptions in settings.';

/// When there is no new Exercise created by the Clinician for the user.
const String descNoExerciseAvailable =
    'No exercise prescription available, please '
    'contact your clinician or turn on '
    'custom prescriptions in settings.';

/// Regex pattern for emain address (do not modify).
const String emailRegEx =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

/// Possible errors catched by the Firebase Authentication proccess.
/// Keys for this map are the (error) codes produced by the Firebase.
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
