import 'package:loyalty_admin/services/base_api/base_api_service.dart';
import 'package:loyalty_admin/services/config/api_endpoints.dart';

class GetAppPermissionApiService extends BaseApiService {
  Future<Map<String, dynamic>?> getAppManagement() {
    return get(
      ApiEndpoints.getPermission,
      authRequired: true,
    );
  }
}
