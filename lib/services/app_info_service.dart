import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppInfoService {
  AppInfoService._();

  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  static String? _version;
  static String? _build;
  static String? _deviceId;

  static Future<void> init() async {
    final info = await PackageInfo.fromPlatform();
    _version = info.version;
    _build = info.buildNumber;
    _deviceId = await _getDeviceId();
  }

  static String get appVersion => _version ?? '';
  static String get buildNumber => _build ?? '';
  static String get deviceId => _deviceId ?? '';

  static String get deviceType {
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    return 'unknown';
  }


  static Future<String?> _getDeviceId() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        return androidInfo.id; // ANDROID_ID
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        return iosInfo.identifierForVendor; // IDFV
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}
