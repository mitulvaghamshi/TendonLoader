var progressor_uuids = {
  "7e4e1701-1ea6-40c9-9dcc-13d34ffead57": "Progressor Service",
  "7e4e1702-1ea6-40c9-9dcc-13d34ffead57": "Data",
  "7e4e1703-1ea6-40c9-9dcc-13d34ffead57": "Control point",
};
/*

TARGET_NAME = "Progressor"

""" Progressor Commands """
CMD_TARE_SCALE = 100
CMD_START_WEIGHT_MEAS = 101
CMD_STOP_WEIGHT_MEAS = 102
CMD_START_PEAK_RFD_MEAS = 103
CMD_START_PEAK_RFD_MEAS_SERIES = 104
CMD_ADD_CALIBRATION_POINT = 105
CMD_SAVE_CALIBRATION = 106
CMD_GET_APP_VERSION = 107
CMD_GET_ERROR_INFORMATION = 108
CMD_CLR_ERROR_INFORMATION = 109
CMD_ENTER_SLEEP = 110
CMD_GET_BATTERY_VOLTAGE = 111

""" Progressor response codes """
RES_CMD_RESPONSE = 0
RES_WEIGHT_MEAS = 1
RES_RFD_PEAK = 2
RES_RFD_PEAK_SERIES = 3
RES_LOW_PWR_WARNING = 4

*/

/* [Power on device]
Activate your device by pressing the button, then press scan to find your device
*/

/* [turn on bluetooth]
This app needs bluetooth to comunicate with your Progresssor. Please enable bluetooth on your device.
*/

/* [Enable location: GPS]
[big bold font] This app uses bluetoothto communicate with your progressor.
[regular font] Scanning for bluetooth devices can be used to locate you. That's why we ask you to permit location services. We're only using this permission to scan for your Progressor.
[new line] We'll never collect your physical location.
*/