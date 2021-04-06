mixin Sizes {
  static const double sizeWeb = 768;
  static const double sizeMobile = 350;
  static const double sizeLeftPanel = 400;
}

mixin Keys {
  static const String keyLoginBox = 'loginBox';

  static const String keyStaySignIn = '_KEY_STAY_SIGNED_IN';
  static const String keyUsername = '_KEY_USERNAME';
  static const String keyPassword = '_KEY_PASSWORD';
}

mixin Images {
  static const String imgRoot = 'assets/images/';
  static const String imgAppLogo = 'app_logo.svg';
  static const String imgEnableDevice = 'enable_device.png';
  static const String imgEnableLocation = 'enable_location.png';
  static const String imgEnableBluetooth = 'enable_bluetooth.png';
}

mixin Descriptions {
  static const String descEnableDevice = 'Activate your device by pressing the button, then press scan to find the device';
  static const String descClickToConnect = 'Available devices.\nClick to connect/disconnect';
  static const String descLocation1 = 'This app uses bluetooth to communicate with your Progressor.';
  static const String descLocation2 =
      'Scanning for bluetooth devices can be used to locate you. That\'s why we ask you to permit location services. We\'re only using this permission to scan for your Progressor.';
  static const String descLocation3 = 'We\'ll never collect your physical location.';
  static const String descEnableBluetooth =
      '\nThis app needs Bluetooth to communicate with your Progressor.\n\nPlease enable Bluetooth on your device.';
  static const String desc6 = '';
}

mixin Progressor {
  // UUIDs
  static const String serviceUuid = '7e4e1701-1ea6-40c9-9dcc-13d34ffead57'; // main service
  static const String controlPointUuid = '7e4e1703-1ea6-40c9-9dcc-13d34ffead57'; // send commands
  static const String dataCharacteristicUuid = '7e4e1702-1ea6-40c9-9dcc-13d34ffead57'; // receive data

  // Responses
  static const int RES_CMD_RESPONSE = 0;
  static const int RES_WEIGHT_MEAS = 1;
  static const int RES_RFD_PEAK = 2;
  static const int RES_RFD_PEAK_SERIES = 3;
  static const int RES_LOW_PWR_WARNING = 4;

  // Commands
  static const int CMD_TARE_SCALE = 100;
  static const int CMD_START_WEIGHT_MEAS = 101;
  static const int CMD_STOP_WEIGHT_MEAS = 102;
  static const int CMD_START_PEAK_RFD_MEAS = 103;
  static const int CMD_START_PEAK_RFD_MEAS_SERIES = 104;
  static const int CMD_ADD_CALIBRATION_POINT = 105;
  static const int CMD_SAVE_CALIBRATION = 106;
  static const int CMD_GET_APP_VERSION = 107;
  static const int CMD_GET_ERROR_INFORMATION = 108;
  static const int CMD_CLR_ERROR_INFORMATION = 109;
  static const int CMD_ENTER_SLEEP = 110;
  static const int CMD_GET_BATTERY_VOLTAGE = 111;
}
