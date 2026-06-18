import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:loyalty_admin/Modules/Dashboard/permission_controller.dart';
import 'package:loyalty_admin/routes/app_routes.dart';
import 'package:loyalty_admin/services/config/api_endpoints.dart';
import 'package:loyalty_admin/services/storage/secure_storage_service.dart';

class RefreshTokenApiService {
  static Future<String?>? _inFlight;

  Future<String?> refreshAccessToken() {
    return _inFlight ??= _refresh().whenComplete(() {
      _inFlight = null;
    });
  }

  Future<String?> _refresh() async {
    try {
      final refreshToken = await SecureStorageService.getRefreshToken();

      debugPrint('REFRESH TOKEN => $refreshToken');

      if (refreshToken == null || refreshToken.isEmpty) {
        return null;
      }

      final response = await http
          .post(
            Uri.parse(ApiEndpoints.refreshTokenUrl),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              // IMPORTANT
              "refreshToken": refreshToken,
            }),
          )
          .timeout(const Duration(seconds: 20));

      debugPrint("""
REFRESH RESPONSE

STATUS :
${response.statusCode}

BODY :
${response.body}
""");

      if (response.statusCode != 200) {
        return null;
      }

      final json = jsonDecode(response.body);

      if (json['success'] != true) {
        return null;
      }

      final data = json['data'];

      final accessToken = data['accessToken'];

      final newRefresh = data['refreshToken'] ?? refreshToken;

      if (accessToken == null || accessToken.toString().isEmpty) {
        return null;
      }

      await SecureStorageService.saveTokens(
        accessToken: accessToken,
        refreshToken: newRefresh,
      );

      if (Get.isRegistered<ActivityTypeController>()) {
        await Get.find<ActivityTypeController>().loadPermissions();
      }

      debugPrint('NEW TOKEN SAVED');

      return accessToken;
    } on SocketException {
      return null;
    } on TimeoutException {
      return null;
    } catch (e) {
      debugPrint('REFRESH ERROR $e');

      return null;
    }
  }
}
