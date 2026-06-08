import 'package:loyalty_admin/services/app_info_service.dart';
import 'package:loyalty_admin/services/base_api/base_api_service.dart';
import 'package:loyalty_admin/services/config/api_endpoints.dart';

class LoginApiService extends BaseApiService {

  Future<Map<String, dynamic>?> login({
    required String email,
    required String password,
  }) {
    return post(
      ApiEndpoints.loginUrl,
      body: {
        "email": email,
        "password": password,
      },
      authRequired: false,
      extraHeaders: {
        'x-app-version': AppInfoService.appVersion,
        'x-build-number': AppInfoService.buildNumber,
        'x-device-type': AppInfoService.deviceType,
        'x-device-id': AppInfoService.deviceId
      },
    );
  }
}
