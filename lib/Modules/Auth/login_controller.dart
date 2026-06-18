import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_admin/Modules/Dashboard/permission_controller.dart';
import 'package:loyalty_admin/modules/Dashboard/common_bottom_bar.dart';
import 'package:loyalty_admin/models/login_response_model.dart';
import 'package:loyalty_admin/routes/app_routes.dart';
import 'package:loyalty_admin/services/network/login_api_service.dart';
import 'package:loyalty_admin/services/network/logout_api_service.dart';
import 'package:loyalty_admin/services/storage/secure_storage_service.dart';

class LoginController extends GetxController {
  final api = LoginApiService();
  final _api = LogoutApiService();

  final emailController = TextEditingController();
  final passWordController = TextEditingController();


   var isLoading = false.obs;
    RxBool isPasswordVisible = false.obs;   // ← added

    final emailError = RxnString();         // ← null when valid

    void togglePasswordVisibility() {       // ← added
      isPasswordVisible.toggle();
    }

    /// Returns true when the email field holds a syntactically valid address.
    bool validateEmail() {
      final email = emailController.text.trim();
      if (email.isEmpty) {
        emailError.value = "Email is required";
        return false;
      }

      final emailRegex = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');
      if (!emailRegex.hasMatch(email)) {
        emailError.value = "Please enter a valid email address";
        return false;
      }

      emailError.value = null;
      return true;
    }

  @override
  void onInit() {
    super.onInit();
    checkLogin();
  }

  Future<void> checkLogin() async {
    final token = await SecureStorageService.getAccessToken();
    if (token != null && token.isNotEmpty) {
      Get.offAll(() => const CommonBottomBar());
    }
  }

  Future<void> loginUser() async {
    if (!validateEmail()) return;

    isLoading.value = true;

    try {
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
        final accessToken = result.data?.accessToken;
        final refreshToken = result.data?.refreshToken;

        if (accessToken == null || refreshToken == null) {
          Get.snackbar("Error", "Invalid token response");
          return;
        }

        await SecureStorageService.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );

         // Use the raw admin object from the API so all permission/module fields
        // (permissions, modules, etc.) are preserved and passed to the web app.
        final rawAdmin = jsonResponse['data']?['admin'];
        final userMap = rawAdmin is Map<String, dynamic>
            ? rawAdmin
            : {
                'id': result.data!.admin.id,
                'name': result.data!.admin.name,
                'email': result.data!.admin.email,
                'role': result.data!.admin.role,
                'restaurant_id': result.data!.admin.restaurantId,
                if (result.data!.admin.roleId != null)
                  'roleId': result.data!.admin.roleId,
              };
        await SecureStorageService.saveUser(
          Map<String, dynamic>.from(userMap),
        );

        //Get.offAll(() => const CommonBottomBar());
        final activityController = Get.put(
          ActivityTypeController(),
          permanent: true,
        );

        await activityController.loadPermissions();

        Get.offAll(() => const CommonBottomBar());
      } else {
        final errorMessage = result.message == "Validation failed"
            ? "Please enter a valid email and password"
            : result.message;

        Get.rawSnackbar(
          messageText: Text(  
            errorMessage,
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
      if (!isClosed) isLoading.value = false;
    }
  }

  static Future<void> handleLogout() async {
    try {
      await LogoutApiService().logOut();
    } catch (e) {
      debugPrint("Logout error: $e");
    } finally {
      await SecureStorageService.clearTokens();
      Get.offAllNamed(AppRoutes.login);
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passWordController.dispose();
    super.onClose();
  }
}
