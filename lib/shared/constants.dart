mixin Sizes {
  static const double SIZE_LEFT_PANEL = 370;
}

mixin Keys {
  static const String KEY_LOGIN_BOX = '_key_login_box';
  static const String KEY_USER_EXPORTS_BOX = '_key_user_exports_box';
  static const String KEY_PRESCRIPTION_BOX = '_key_prescription_box';

  static const String KEY_USERNAME = '_key_username';
  static const String KEY_PASSWORD = '_key_password';
  static const String KEY_STAY_SIGN_IN = '_key_stay_signed_in';
  static const String KEY_IS_FIRST_TIME = '_key_is_first_time';

  static const String KEY_SETS = '_key_sets';
  static const String KEY_REPS = '_key_reps';
  static const String KEY_LAST_MVC = '_last_mvc';
  static const String KEY_HOLD_TIME = '_key_hold_time';
  static const String KEY_REST_TIME = '_key_rest_time';
  static const String KEY_TARGET_LOAD = '_key_target_load';
  static const String KEY_DATA_STATUS = '_key_data_status';
  static const String KEY_PROGRESSOR_ID = '_key_progressor_id';
  static const String KEY_PRESCRIPTION = '_key_prescription';

  static const String KEY_CHART_Y = 'time';
  static const String KEY_CHART_X = 'load';

  static const String KEY_PREFIX_MVC = 'mvc_test';
  static const String KEY_PREFIX_EXERCISE = 'exercise';
  static const String KEY_DATE_FORMAT = 'y-MM-dd';
  static const String KEY_TIME_FORMAT = 'hh:mm:ss a';

  static const String KEY_META_DATA = '_key_meta_data';
  static const String KEY_USER_DATA = '_key_user_data';
  static const String KEY_EXPORT_TYPE = '_key_export_type';
  static const String KEY_EXPORT_DATE = '_key_export_date';
  static const String KEY_EXPORT_TIME = '_key_export_time';

  static const String KEY_ALL_USERS = 'all-users';
  static const String KEY_ALL_EXPORTS = 'all-exports';
  static const String KEY_LAST_ACTIVE = '_key_last_active';
}

mixin Images {
  static const String IMG_ROOT = 'assets/images/';
  static const String IMG_APP_LOGO = IMG_ROOT + 'app_logo.svg';
  static const String IMG_ENABLE_DEVICE = IMG_ROOT + 'enable_device.png';
  static const String IMG_ENABLE_LOCATION = IMG_ROOT + 'enable_location.png';
  static const String IMG_ENABLE_BLUETOOTH = IMG_ROOT + 'enable_bluetooth.png';
}

mixin Descriptions {
  static const String DESC_ENABLE_DEVICE =
      'Activate your device by pressing the button, then press scan to find the device';
  static const String DESC_CLICK_TO_CONNECT = 'Available devices';
  static const String DESC_ENABLE_BLUETOOTH =
      '\nThis app needs Bluetooth to communicate with your Progressor.\n\nPlease enable Bluetooth on your device.';
  static const String DESC_LOCATION_1 = 'This app uses bluetooth to communicate with your Progressor.';
  static const String DESC_LOCATION_2 =
      'Scanning for bluetooth devices can be used to locate you. That\'s why we ask you to permit location services. We\'re only using this permission to scan for your Progressor.';
  static const String DESC_LOCATION_3 = 'We\'ll never collect your physical location.';
}

mixin Progressor {
  // UUIDs
  static const String SERVICE_UUID = '7E4E17011EA640C99DCC13D34FFEAD57'; // (01) main service
  static const String CONTROL_POINT_UUID = '7E4E17031EA640C99DCC13D34FFEAD57'; // (03) send commands
  static const String DATA_CHARACTERISTICS_UUID = '7E4E17021EA640C99DCC13D34FFEAD57'; // (02) receive data

  // static const String SERVICE_UUID = '7e4e1701-1ea6-40c9-9dcc-13d34ffead57'; // (01) main service
  // static const String CONTROL_POINT_UUID = '7e4e1703-1ea6-40c9-9dcc-13d34ffead57'; // (03) send commands
  // static const String DATA_CHARACTERISTICS_UUID = '7e4e1702-1ea6-40c9-9dcc-13d34ffead57'; // (02) receive data

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
  static const int CMD_GET_APP_VERSION = 107; //
  static const int CMD_GET_ERROR_INFORMATION = 108; //
  static const int CMD_CLR_ERROR_INFORMATION = 109;
  static const int CMD_ENTER_SLEEP = 110;
  static const int CMD_GET_BATTERY_VOLTAGE = 111; //
}
