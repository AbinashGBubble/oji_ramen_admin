class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = "https://loyaltydevapi.xpulsar.tech/api/v1/";

  static const String loginUrl = "${baseUrl}admin/login";
  static const String refreshTokenUrl = "${baseUrl}admin/getAccessToken";
  static const String getAllUsers = "${baseUrl}admin/user";
  
  /// Dynamic endpoint
  static String getUser(String cardcode) {
    return "${baseUrl}admin/user/$cardcode";
  }

  static const String calculateBill = "${baseUrl}admin/points/calculate-bill";
}
