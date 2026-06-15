import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loyalty_admin/Modules/Dashboard/permission_controller.dart';
import 'package:loyalty_admin/services/base_api/base_api_service.dart';
import 'package:loyalty_admin/services/config/api_endpoints.dart';
import 'package:loyalty_admin/services/storage/secure_storage_service.dart';

class RefreshTokenApiService extends BaseApiService {
  Future<String?> refreshAccessToken() async {
    try {
      final refreshToken = await SecureStorageService.getRefreshToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        debugPrint("Refresh token missing");
        return null;
      }

      // final headers = {
      //   'Accept': 'application/json',
      //   'Content-Type': 'application/json',
      //   'x-app-code': dotenv.env['x-app-code'] ?? '',
      //   'x-api-key': dotenv.env['x-api-key'] ?? '',
      // };

      final body = jsonEncode({"refresh_token": refreshToken});

      debugPrint("🔄 Refresh token API called");

      final response = await http.post(
        Uri.parse(ApiEndpoints.refreshTokenUrl),
        //headers: headers,
        body: body,
      );

      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200 && jsonResponse['success'] == true) {
        final newAccessToken = jsonResponse['access_token'];

        // await SecureStorageService.saveTokens(
        //   accessToken: newAccessToken,
        //   refreshToken: refreshToken, // keep old refresh token
        // );

        await SecureStorageService.saveTokens(
          accessToken: newAccessToken,

          refreshToken: refreshToken,
        );

        if (Get.isRegistered<PermissionController>()) {
          await Get.find<PermissionController>().loadPermissions();
        }

        debugPrint("New access token generated $newAccessToken");
        return newAccessToken;
      }

      debugPrint("Refresh token expired");
      await SecureStorageService.clearTokens();
      return null;
    } on SocketException {
      debugPrint("No internet (refresh token)");
      return null;
    } catch (e) {
      debugPrint("Refresh token error: $e");
      return null;
    }
  }
}
