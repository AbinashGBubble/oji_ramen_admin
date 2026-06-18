import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:loyalty_admin/routes/app_routes.dart';
import 'package:loyalty_admin/services/network/refresh_token_api_service.dart';
import 'package:loyalty_admin/services/storage/secure_storage_service.dart';

enum HttpMethod { get, post, put, delete }

abstract class BaseApiService {
  final RefreshTokenApiService _refreshService = RefreshTokenApiService();

  static const Duration _timeout = Duration(seconds: 20);

  /* ================= HEADERS ================= */

  Future<Map<String, String>> _buildHeaders({
    bool authRequired = true,
    String? retryToken,
    Map<String, String>? extraHeaders,
  }) async {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    if (authRequired) {
      final token = retryToken ?? await SecureStorageService.getAccessToken();

      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    if (extraHeaders != null) {
      headers.addAll(extraHeaders);
    }

    return headers;
  }

  /* ================= SAFE DECODE ================= */

  Map<String, dynamic> _safeDecode(String body) {
    try {
      return jsonDecode(body);
    } catch (_) {
      return {"success": false, "message": "Invalid server response"};
    }
  }

  /* ================= LOGOUT ================= */

  Future<void> _forceLogout() async {
    await SecureStorageService.clearTokens();

    if (Get.currentRoute != AppRoutes.login) {
      Get.offAllNamed(AppRoutes.login);
    }
  }

  /* ================= REQUEST ================= */

  Future<Map<String, dynamic>?> _request({
    required String url,
    required HttpMethod method,
    Map<String, dynamic>? body,
    bool authRequired = true,
    bool retry = false,
    String? retryToken,
    Map<String, String>? extraHeaders,
  }) async {
    try {
      final uri = Uri.parse(url);

      final headers = await _buildHeaders(
        authRequired: authRequired,
        retryToken: retryToken,
        extraHeaders: extraHeaders,
      );

      late http.Response response;

      switch (method) {
        case HttpMethod.get:
          response = await http.get(uri, headers: headers).timeout(_timeout);
          break;

        case HttpMethod.post:
          response = await http
              .post(
                uri,
                headers: headers,
                body: body != null ? jsonEncode(body) : null,
              )
              .timeout(_timeout);
          break;

        case HttpMethod.put:
          response = await http
              .put(
                uri,
                headers: headers,
                body: body != null ? jsonEncode(body) : null,
              )
              .timeout(_timeout);
          break;

        case HttpMethod.delete:
          response = await http.delete(uri, headers: headers).timeout(_timeout);
          break;
      }

      debugPrint("""
URL : $url
STATUS : ${response.statusCode}
BODY : ${response.body}
""");

      /* ================= REFRESH ================= */

      if (response.statusCode == 401 && authRequired && !retry) {
        final newToken = await _refreshService.refreshAccessToken();

        if (newToken != null) {
          return _request(
            url: url,
            method: method,
            body: body,
            authRequired: authRequired,
            retry: true,
            retryToken: newToken,
            extraHeaders: extraHeaders,
          );
        }

        await _forceLogout();

        return {"success": false, "message": "Session expired"};
      }

      return _safeDecode(response.body);
    } on TimeoutException {
      return {"success": false, "message": "Request timeout"};
    } on SocketException {
      return {"success": false, "message": "No internet"};
    } catch (e) {
      debugPrint("API ERROR : $e");

      return {"success": false, "message": e.toString()};
    }
  }

  /* ================= MULTIPART ================= */

  Future<Map<String, dynamic>?> postMultipart(
    String url, {
    required File file,
    String fileKey = 'file',
    bool authRequired = true,
    bool retry = false,
    String? retryToken,
  }) async {
    try {
      final headers = await _buildHeaders(
        authRequired: authRequired,
        retryToken: retryToken,
      );

      headers.remove('Content-Type');

      final request = http.MultipartRequest('POST', Uri.parse(url));

      request.headers.addAll(headers);

      request.files.add(
        await http.MultipartFile.fromPath(
          fileKey,
          file.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );

      final stream = await request.send();

      final response = await http.Response.fromStream(stream);

      if (response.statusCode == 401 && authRequired && !retry) {
        final token = await _refreshService.refreshAccessToken();

        if (token != null) {
          return postMultipart(
            url,
            file: file,
            fileKey: fileKey,
            authRequired: authRequired,
            retry: true,
            retryToken: token,
          );
        }

        await _forceLogout();
      }

      return _safeDecode(response.body);
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }

  /* ================= PUBLIC ================= */

  Future<Map<String, dynamic>?> get(
    String url, {
    bool authRequired = true,
    Map<String, String>? extraHeaders,
  }) => _request(
    url: url,
    method: HttpMethod.get,
    authRequired: authRequired,
    extraHeaders: extraHeaders,
  );

  Future<Map<String, dynamic>?> post(
    String url, {
    Map<String, dynamic>? body,
    bool authRequired = true,
    Map<String, String>? extraHeaders,
  }) => _request(
    url: url,
    method: HttpMethod.post,
    body: body,
    authRequired: authRequired,
    extraHeaders: extraHeaders,
  );

  Future<Map<String, dynamic>?> put(
    String url, {
    Map<String, dynamic>? body,
    bool authRequired = true,
    Map<String, String>? extraHeaders,
  }) => _request(
    url: url,
    method: HttpMethod.put,
    body: body,
    authRequired: authRequired,
    extraHeaders: extraHeaders,
  );

  Future<Map<String, dynamic>?> delete(
    String url, {
    bool authRequired = true,
    Map<String, String>? extraHeaders,
  }) => _request(
    url: url,
    method: HttpMethod.delete,
    authRequired: authRequired,
    extraHeaders: extraHeaders,
  );
}
