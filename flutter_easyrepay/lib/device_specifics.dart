import 'package:vibrate/vibrate.dart';

class DeviceSpecifics {
  static DeviceSpecifics shared = DeviceSpecifics();
  bool _canVibrate = false;

  DeviceSpecifics() {
    Vibrate.canVibrate.then((value) => _canVibrate = value);
  }

  bool get canVibrate {
    return _canVibrate;
  }
}