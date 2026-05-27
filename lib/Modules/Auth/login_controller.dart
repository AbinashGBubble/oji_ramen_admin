import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_admin/models/login_response_model.dart';
import 'package:loyalty_admin/routes/app_routes.dart';
import 'package:loyalty_admin/services/network/login_api_service.dart';
import 'package:loyalty_admin/services/storage/secure_storage_service.dart';

class LoginController extends GetxController {
  final api = LoginApiService();

  final emailController = TextEditingController();
  final passWordController = TextEditingController();

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkLogin();
  }

  Future<void> checkLogin() async {
  final token = await SecureStorageService.getAccessToken();

  if (token != null && token.isNotEmpty) {
    Get.offAllNamed(AppRoutes.home);
  }
}


  Future<void> loginUser() async {
    isLoading.value = true;

    try {
      // Map<String, String> data = {
      //   "email": emailController.text,
      //   "password": passWordController.text,
      // };

      final jsonResponse = await api.login(
        email: emailController.text,
        password: passWordController.text,
      );

      if (jsonResponse == null) {
        Get.snackbar("Error", "Something went wrong");
        return;
      }

      final result = LoginResponse.fromJson(jsonResponse);

      debugPrint("Admin login response: ${result.message}");

      if (result.success == true) {
        /// Extract tokens
        final accessToken = result.data?.accessToken;
        final refreshToken = result.data?.refreshToken;

        if (accessToken == null || refreshToken == null) {
          Get.snackbar("Error", "Invalid token response");
          return;
        }

        /// Save tokens securely
        await SecureStorageService.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );

        /// Save admin user for WebView session
        final admin = result.data!.admin;
        await SecureStorageService.saveUser({
          'id': admin.id.toString(),
          'name': admin.name,
          'email': admin.email,
          'role': admin.role,
          if (admin.roleId != null) 'roleId': admin.roleId,
        });

        debugPrint("Access Token Saved: $accessToken");
        debugPrint("Refresh Token Saved: $refreshToken");

        /// Navigate to home
        Get.offAllNamed(AppRoutes.home);
      } else {
        Get.rawSnackbar(
          messageText: Text(
            result.message,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.red.shade400,
          margin: const EdgeInsets.all(15),
          borderRadius: 5,
        );
      }
    } catch (e) {
      debugPrint("Login error: $e");
      Get.snackbar("Error", "Unexpected error occurred");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passWordController.dispose();
    super.onClose();
  }
}
