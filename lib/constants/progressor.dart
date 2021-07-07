// UUIDs
const String uuidService = '7e4e1701-1ea6-40c9-9dcc-13d34ffead57'; // main service
const String uuidControl = '7e4e1703-1ea6-40c9-9dcc-13d34ffead57'; // send commands
const String uuidData = '7e4e1702-1ea6-40c9-9dcc-13d34ffead57'; // receive data

// Responses
const int resCommandResponse = 0;
const int resWeightMeasurement = 1;
const int resRFDPeak = 2;
const int resRFDPeakSeries = 3;
const int resLowPowerWarning = 4;

// Commands
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
