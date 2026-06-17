import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loyalty_admin/Modules/Dashboard/permission_controller.dart';
import 'package:loyalty_admin/routes/app_routes.dart';
import 'package:loyalty_admin/services/config/api_endpoints.dart';
import 'package:loyalty_admin/services/storage/secure_storage_service.dart';

class RefreshTokenApiService {
  /// Single-flight guard. When several API calls receive a 401 at the same
  /// time (access token just expired), they all ask for a refresh. Without
  /// this, each would POST the refresh endpoint separately — and if the
  /// backend rotates refresh tokens, all but the first would fail and log the
  /// user out. Sharing one in-flight future fixes that.
  static Future<String?>? _inFlight;

  Future<String?> refreshAccessToken() {
    return _inFlight ??= _doRefresh().whenComplete(() => _inFlight = null);
  }

  Future<String?> _doRefresh() async {
    try {
      final refreshToken = await SecureStorageService.getRefreshToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        debugPrint("Refresh token missing");
        await _forceLogout();
        return null;
      }

      debugPrint("🔄 Refresh token API called");

      final response = await http.post(
        Uri.parse(ApiEndpoints.refreshTokenUrl),
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"refresh_token": refreshToken}),
      );

      Map<String, dynamic> jsonResponse;
      try {
        jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      } catch (_) {
        jsonResponse = {};
      }

      final success = jsonResponse['success'] == true;

      if (response.statusCode == 200 && success) {
        final newAccessToken = _extractAccessToken(jsonResponse);

        if (newAccessToken == null || newAccessToken.isEmpty) {
          debugPrint("Refresh succeeded but no access token in response");
          await _forceLogout();
          return null;
        }

        // The backend may rotate the refresh token. Persist the new one if
        // present, otherwise keep the existing token.
        final newRefreshToken =
            _extractRefreshToken(jsonResponse) ?? refreshToken;

        await SecureStorageService.saveTokens(
          accessToken: newAccessToken,
          refreshToken: newRefreshToken,
        );

        if (Get.isRegistered<PermissionController>()) {
          await Get.find<PermissionController>().loadPermissions();
        }

        debugPrint("New access token generated");
        return newAccessToken;
      }

      debugPrint("Refresh token expired or rejected (${response.statusCode})");
      await _forceLogout();
      return null;
    } on SocketException {
      // No connectivity — don't wipe tokens, the user may simply be offline.
      debugPrint("No internet (refresh token)");
      return null;
    } catch (e) {
      debugPrint("Refresh token error: $e");
      return null;
    }
  }

  /// Reads the access token regardless of whether the API returns it at the
  /// top level (`access_token` / `accessToken`) or nested under `data`.
  String? _extractAccessToken(Map<String, dynamic> json) {
    final data = json['data'];
    final source = data is Map<String, dynamic> ? data : json;
    final value = source['access_token'] ?? source['accessToken'];
    return value is String ? value : value?.toString();
  }

  String? _extractRefreshToken(Map<String, dynamic> json) {
    final data = json['data'];
    final source = data is Map<String, dynamic> ? data : json;
    final value = source['refresh_token'] ?? source['refreshToken'];
    if (value is String && value.isNotEmpty) return value;
    return null;
  }

  Future<void> _forceLogout() async {
    await SecureStorageService.clearTokens();
    // Avoid stacking redirects if we're already on the login screen.
    if (Get.currentRoute != AppRoutes.login) {
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
