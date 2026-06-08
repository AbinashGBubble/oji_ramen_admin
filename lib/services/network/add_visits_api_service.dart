import 'package:loyalty_admin/services/base_api/base_api_service.dart';
import 'package:loyalty_admin/services/config/api_endpoints.dart';

class AddvisistsApiService extends BaseApiService {
  Future<Map<String, dynamic>?> addvisits({required int id}) {
    return post(ApiEndpoints.addVisits(id),body: {}, authRequired: true);
  }
}
