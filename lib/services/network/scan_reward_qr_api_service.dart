import 'package:loyalty_admin/services/base_api/base_api_service.dart';
import 'package:loyalty_admin/services/config/api_endpoints.dart';

class ScanRewardQrApiService extends BaseApiService {
  Future<Map<String, dynamic>?> rewardLookUp({required String identifier}) {
    return get(ApiEndpoints.rewardLookUp(identifier), authRequired: true);
  }

   Future<Map<String, dynamic>?> reedemReward({required int id}) {
    return get(ApiEndpoints.redeemReward(id), authRequired: true);
  }
}
