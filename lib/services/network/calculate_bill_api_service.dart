import 'package:loyalty_admin/services/base_api/base_api_service.dart';
import 'package:loyalty_admin/services/config/api_endpoints.dart';

class CalculateApiService extends BaseApiService {

  Future<Map<String, dynamic>?> calculateBill({
    required String couponCode,
    required String billAmount,
    required String userId,
  }) {
    return post(
      ApiEndpoints.calculateBill,
      {
        "coupon_code": couponCode,
        "bill_amount": billAmount,
        "user_id": userId,
      },
      authRequired: true,
    );
  }
}
