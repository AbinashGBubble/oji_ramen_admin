class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = "https://loyaltydevapi.pryzma.in/api/v1/";

  static const String loginUrl = "${baseUrl}admin/login";
  static const String logoutUrl = "${baseUrl}admin/logout";
  static const String refreshTokenUrl = "${baseUrl}admin/get-access-token";

  static String userLookUp(String identifier) {
    return "${baseUrl}admin/userLookUp?identifier=$identifier";
  }

  static String rewardLookUp(String identifier) {
    return "${baseUrl}admin/rewardLookUp?identifier=$identifier";
  }

  static String addVisits(int id) => "${baseUrl}admin/addVisit/$id";
  static String redeemReward(int id) => "${baseUrl}admin/redeemReward/$id";

  static const String getPermission = "${baseUrl}admin/permission";

  // /// Dynamic endpoint
  // static String getUser(String cardcode) {
  //   return "${baseUrl}admin/user/$cardcode";
  // }

  // static const String calculateBill = "${baseUrl}admin/points/calculate-bill";
}
