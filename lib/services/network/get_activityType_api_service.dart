import 'package:loyalty_admin/services/base_api/base_api_service.dart';
import 'package:loyalty_admin/services/config/api_endpoints.dart';

class GetActivityTypeApiService extends BaseApiService {
  Future<Map<String, dynamic>?> getActivityType() {
    return get(
      ApiEndpoints.getActivity,
      authRequired: true,
    );
  }
}
