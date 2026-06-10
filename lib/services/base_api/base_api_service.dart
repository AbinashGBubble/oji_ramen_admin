import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:loyalty_admin/services/network/refresh_token_api_service.dart';
import 'package:loyalty_admin/services/storage/secure_storage_service.dart';

abstract class BaseApiService {
  /* ================= HEADERS ================= */

  Future<Map<String, String>> _buildHeaders({
    bool authRequired = true,
    Map<String, String>? extraHeaders,
  }) async {
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    if (authRequired) {
      final token = await SecureStorageService.getAccessToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    // ✅ MERGE EXTRA HEADERS
    if (extraHeaders != null && extraHeaders.isNotEmpty) {
      headers.addAll(extraHeaders);
    }

    return headers;
  }

  /* ================= REQUEST HANDLER ================= */

  Future<Map<String, dynamic>?> _request({
    required String url,
    required HttpMethod method,
    Map<String, dynamic>? body,
    bool authRequired = true,
    bool retry = false,
    Map<String, String>? extraHeaders,
  }) async {
    try {
      final uri = Uri.parse(url);

      final headers = await _buildHeaders(
        authRequired: authRequired,
        extraHeaders: extraHeaders,
      );

      debugPrint("API URL: $uri");

      late http.Response response;

      switch (method) {
        case HttpMethod.post:
          response = await http.post(
            uri,
            headers: headers,
            body: jsonEncode(body),
          );
          break;

        case HttpMethod.put:
          response = await http.put(
            uri,
            headers: headers,
            body: body != null && body.isNotEmpty ? jsonEncode(body) : null,
          );
          break;

        case HttpMethod.delete:
          response = await http.delete(
            uri,
            headers: headers,
          );
          break;

        case HttpMethod.get:
          response = await http.get(
            uri,
            headers: headers,
          );
          break;
      }

      // 🔁 TOKEN REFRESH
      if (response.statusCode == 401 && authRequired && !retry) {
        final newToken = await RefreshTokenApiService().refreshAccessToken();

        if (newToken != null) {
          return _request(
            url: url,
            method: method,
            body: body,
            authRequired: authRequired,
            retry: true,
            extraHeaders: extraHeaders,
          );
        }
        return null;
      }

      // ✅ SUCCESS
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      }

      // ❌ ERROR RESPONSE
      return jsonDecode(response.body);
    } on SocketException {
      debugPrint("No internet connection");
      return null;
    } catch (e) {
      debugPrint("API error: $e");
      return null;
    }
  }

  // multipart request
  Future<Map<String, dynamic>?> postMultipart(
    String url, {
    required File file,
    String fileKey = 'file',
    bool authRequired = true,
  }) async {
    try {
      final uri = Uri.parse(url);

      final headers = await _buildHeaders(
        authRequired: authRequired,
        extraHeaders: {
          'Content-Type': 'multipart/form-data',
        },
      );

      final extension = file.path.split('.').last.toLowerCase();

      String mimeType = 'image/jpeg';
      if (extension == 'png') mimeType = 'image/png';
      if (extension == 'jpg' || extension == 'jpeg') mimeType = 'image/jpeg';

      final request = http.MultipartRequest('POST', uri);
      request.headers.addAll(headers);

      request.files.add(
        await http.MultipartFile.fromPath(
          fileKey,
          file.path,
          contentType: http.MediaType.parse(mimeType),
        ),
      );

      debugPrint("API URL: $uri");

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      // 🔁 TOKEN REFRESH
      if (response.statusCode == 401 && authRequired) {
        final newToken = await RefreshTokenApiService().refreshAccessToken();

        if (newToken != null) {
          return postMultipart(
            url,
            file: file,
            fileKey: fileKey,
            authRequired: authRequired,
          );
        }
        return null;
      }

      return jsonDecode(response.body);
    } catch (e) {
      debugPrint("Multipart error: $e");
      return null;
    }
  }

  /* ================= PUBLIC METHODS ================= */

  Future<Map<String, dynamic>?> get(
    String url, {
    bool authRequired = true,
    Map<String, String>? extraHeaders,
  }) =>
      _request(
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
}) =>
    _request(
      url: url,
      method: HttpMethod.post,
      body: body,
      authRequired: authRequired,
      extraHeaders: extraHeaders,
    );

  Future<Map<String, dynamic>?> put(
    String url, {
    bool authRequired = true,
    Map<String, dynamic>? body,
    Map<String, String>? extraHeaders,
  }) =>
      _request(
        url: url,
        method: HttpMethod.put,
        body: body,
        authRequired: authRequired,
        extraHeaders: extraHeaders,
      );
}

enum HttpMethod { get, post, put, delete }
