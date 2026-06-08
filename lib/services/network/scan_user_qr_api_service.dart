import 'package:loyalty_admin/services/base_api/base_api_service.dart';
import 'package:loyalty_admin/services/config/api_endpoints.dart';

class ScanUserQrApiService extends BaseApiService {
  Future<Map<String, dynamic>?> userLookUp({required String identifier}) {
    return get(ApiEndpoints.userLookUp(identifier), authRequired: true);
  }
}
