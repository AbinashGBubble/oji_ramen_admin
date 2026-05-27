import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_admin/Modules/ScanQr/calculate_bill_model.dart';
import 'package:loyalty_admin/Modules/redeem/get_user_model.dart';
import 'package:loyalty_admin/services/network/calculate_bill_api_service.dart';
import 'package:loyalty_admin/services/network/get_user_api_service.dart';

class EarnRedeemController extends GetxController {
  /// SERVICES
  final _api = GetUserApiService();
  final _calculateApi = CalculateApiService();

  /// USER STATE
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final userData = Rxn<UserData>();

  late final String cardcode;

  /// BILL STATE
  final isCalculating = false.obs;
  final billData = Rxn<BillData>();

  /// ERROR STATE
  final isError = false.obs;
  final errorText = ''.obs;

  /// INPUT CONTROLLERS
  final billAmountController = TextEditingController();
  final couponCodeController = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    if (args == null || args is! String) {
      errorMessage.value = 'Invalid cardcode';
      return;
    }

    cardcode = args;
    fetchUser();
  }

  /// =========================
  /// FETCH USER
  /// =========================
  Future<void> fetchUser() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _api.getUser(cardcode: cardcode);

      if (response == null) {
        errorMessage.value = "Unable to fetch user";
        return;
      }

      final result = GetUserResponse.fromJson(response);

      if (result.success == true) {
        userData.value = result.data;
        debugPrint("User loaded: ${result.data}");
      } else {
        errorMessage.value = result.message ?? "Something went wrong";
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// =========================
  /// CALCULATE BILL
  /// =========================
  Future<void> calculateBill({
    required String couponCode,
    required String billAmount,
  }) async {
    try {
      /// 🔄 Start loading
      isCalculating.value = true;
      isError.value = false;

      /// ✅ VALIDATION
      if (billAmount.trim().isEmpty) {
        _setError("Please enter bill amount");
        return;
      }

      final userId = userData.value?.id;

      if (userId == null) {
        _setError("User not loaded");
        return;
      }

      /// 🔥 API CALL
      final response = await _calculateApi.calculateBill(
        couponCode: couponCode.trim(),
        billAmount: billAmount.trim(),
        userId: userId.toString(),
      );

      /// ❌ NULL RESPONSE
      if (response == null) {
        _setError("Failed to calculate bill");
        return;
      }

      /// 🔥 MAP → MODEL
      final result = BillResponse.fromJson(response);

      /// ❌ API FAILURE
      if (result.success != true) {
        _setError(result.message ?? "Calculation failed");
        return;
      }

      /// ✅ SUCCESS
      billData.value = result.data;

      debugPrint("Bill calculated: ${result.toJson()}");

    } catch (e) {
      _setError(e.toString());
    } finally {
      /// 🔄 Stop loading
      isCalculating.value = false;
    }
  }

  /// =========================
  /// COMMON ERROR HANDLER
  /// =========================
  void _setError(String message) {
    isError.value = true;
    errorText.value = message;

    Get.snackbar("Error", message);
  }

  @override
  void onClose() {
    /// 🧹 Dispose controllers
    billAmountController.dispose();
    couponCodeController.dispose();
    super.onClose();
  }
}