import 'package:loyalty_admin/services/base_api/base_api_service.dart';
import 'package:loyalty_admin/services/config/api_endpoints.dart';

class GetUserApiService extends BaseApiService {

  Future<Map<String, dynamic>?> getUser({required String cardcode}) {

    return get(
      ApiEndpoints.getUser(cardcode),
      authRequired: true,
    );
  }
}
