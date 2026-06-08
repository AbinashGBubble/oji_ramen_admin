import 'package:loyalty_admin/services/base_api/base_api_service.dart';
import 'package:loyalty_admin/services/config/api_endpoints.dart';

class LogoutApiService extends BaseApiService {
  Future<Map<String, dynamic>?> logOut() {
    return post(
      ApiEndpoints.loginUrl,
      authRequired: true,
    );
  }
}
