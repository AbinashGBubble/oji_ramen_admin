import 'dart:async';
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
  /// Single-flight guard — when several API calls receive a 401 simultaneously
  /// (access token just expired) they all share one in-flight refresh instead
  /// of each POSTing the endpoint separately. If the backend rotates refresh
  /// tokens, only the first caller would win; the rest would force-logout.
  static Future<String?>? _inFlight;

  Future<String?> refreshAccessToken() {
    return _inFlight ??= _doRefresh().whenComplete(() => _inFlight = null);
  }

  Future<String?> _doRefresh() async {
    try {
      final refreshToken = await SecureStorageService.getRefreshToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        debugPrint('Refresh token missing — forcing logout');
        await _forceLogout();
        return null;
      }
      

      debugPrint('Refreshing access token… ${refreshToken}');

      final response = await http
          .post(
            Uri.parse(ApiEndpoints.refreshTokenUrl),
            headers: const {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({'refresh_token': refreshToken}),
          )
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              // Return a synthetic 408 so the caller treats it as a transient
              // error rather than a permanent token failure.
              debugPrint('Refresh token request timed out');
              return http.Response('{"success":false,"message":"timeout"}', 408);
            },
          );
        if (response.statusCode == 400 ||
            response.statusCode == 401 ||
            response.statusCode == 403) {
          debugPrint(
            'Refresh token rejected (${response.statusCode}) — forcing logout',
          );
          await _forceLogout();
          return null;
        
        }
      if (response.statusCode >= 500 ||
          response.statusCode == 408 ||
          response.statusCode == 429) {
        debugPrint(
          ' Refresh endpoint transient error (${response.statusCode}) — '
          'keeping session alive',
        );
        return null; // caller shows error, no logout
      }

      // ── Parse body ──────────────────────────────────────────────────────
      Map<String, dynamic> jsonResponse;
      try {
        jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      } catch (_) {
        jsonResponse = {};
      }

      final success = jsonResponse['success'] == true;

      // ── Success path ────────────────────────────────────────────────────
      if (response.statusCode == 200 && success) {
        final newAccessToken = _extractAccessToken(jsonResponse);

        if (newAccessToken == null || newAccessToken.isEmpty) {
          debugPrint('Refresh succeeded but no access token in response');
          await _forceLogout();
          return null;
        }

        // Backend may rotate the refresh token. Persist the new one if
        // present, otherwise keep the current token.
        final newRefreshToken =
            _extractRefreshToken(jsonResponse) ?? refreshToken;

        await SecureStorageService.saveTokens(
          accessToken: newAccessToken,
          refreshToken: newRefreshToken,
        );

        if (Get.isRegistered<PermissionController>()) {
          await Get.find<PermissionController>().loadPermissions();
        }

        debugPrint('Access token refreshed successfully');
        return newAccessToken;
      }

      // ── 401 / 403 — refresh token is genuinely expired or revoked ───────
      // Only force-logout when the server explicitly rejects the refresh token.
      if (response.statusCode == 401 || response.statusCode == 403) {
        debugPrint(
          ' Refresh token rejected (${response.statusCode}) — forcing logout',
        );
        await _forceLogout();
        return null;
      }

      // ── Any other unexpected status (e.g. 400 bad-request) ──────────────
      // Treat as transient — do not wipe the session.
      debugPrint(
        'Unexpected refresh response (${response.statusCode}) — '
        'keeping session alive',
      );
      return null;
    } on SocketException {
      // Device is offline — keep the session alive so the user isn't
      // logged out just because they temporarily lost connectivity.
      debugPrint('No internet during token refresh — session preserved');
      return null;
    } on TimeoutException {
      // Redundant guard: the http.timeout above converts this to a 408, but
      // keep this catch in case the timeout fires before the Future wraps.
      debugPrint('⏱ Token refresh timed out (TimeoutException)');
      return null;
    } catch (e) {
      debugPrint(' Token refresh unexpected error: $e');
      // Unknown error — do NOT force-logout. The session might still be valid.
      return null;
    }
  }

  // ── Token extraction helpers ─────────────────────────────────────────────

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

  // ── Force logout ─────────────────────────────────────────────────────────

  Future<void> _forceLogout() async {
    await SecureStorageService.clearTokens();
    // Guard against stacking redirects if we're already on the login screen.
    if (Get.currentRoute != AppRoutes.login) {
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
