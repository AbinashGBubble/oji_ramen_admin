import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;

import 'package:loyalty_admin/services/config/api_endpoints.dart';
import 'package:loyalty_admin/services/storage/secure_storage_service.dart';

// Add this key class so CommonBottomBar can call reload()
class PwaWebViewKey extends GlobalKey<_PwaWebViewScreenState> {
  const PwaWebViewKey() : super.constructor();
}

class PwaWebViewScreen extends StatefulWidget {
  final String url;
  final String title;

  const PwaWebViewScreen({super.key, required this.url, required this.title});

  @override
  State<PwaWebViewScreen> createState() => _PwaWebViewScreenState();
}

class _PwaWebViewScreenState extends State<PwaWebViewScreen>
    with AutomaticKeepAliveClientMixin {
  InAppWebViewController? controller;

  // Session values resolved once in initState and reused by onLoadStop
  // every time the page (re)loads.
  bool _sessionReady = false;
  String? _accessToken;
  String? _refreshToken;
  String _userJson = '{}';

  @override
  bool get wantKeepAlive => true;

  String get _reloadKey =>
      '__flutter_reloaded_${widget.title.replaceAll(' ', '_').toLowerCase()}';

  @override
  void initState() {
    super.initState();
    _prepareSession();
  }

  // ← NEW: called by CommonBottomBar when Home tab is tapped
  Future<void> reloadToHome() async {
    if (controller == null) return;
    await controller!.loadUrl(
      urlRequest: URLRequest(url: WebUri(widget.url)),
    );
  }

  bool _isValidPermMap(dynamic perms) {
    return perms != null && perms is Map && perms.isNotEmpty;
  }

  Future<Map<String, dynamic>> _withPermissions(
    Map<String, dynamic> userMap,
    String token,
  ) async {
    final roleId = userMap['roleId'];
    if (roleId == null) return userMap;

    try {
      final response = await http.get(
        Uri.parse('${ApiEndpoints.baseUrl}admin/role/$roleId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) return userMap;

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final roleData = (body['data'] ?? body) as Map<String, dynamic>;
      final rolePermissions = roleData['rolePermissions'] as List<dynamic>?;

      if (rolePermissions == null || rolePermissions.isEmpty) return userMap;

      final permMap = <String, dynamic>{};
      for (final rp in rolePermissions) {
        final name = rp['permission']?['name'] as String?;
        if (name == null) continue;
        permMap[name] = {
          'view': rp['can_view'] ?? false,
          'create': rp['can_add'] ?? false,
          'edit': rp['can_edit'] ?? false,
          'delete': rp['can_delete'] ?? false,
          'export': rp['can_export'] ?? false,
        };
      }

      if (permMap.isEmpty) return userMap;

      final updated = {...userMap, 'permissions': permMap};
      await SecureStorageService.saveUser(updated);
      return updated;
    } catch (e) {
      debugPrint('Permission fetch error [${widget.title}]: $e');
      return userMap;
    }
  }

  // Resolves token/user data once before the WebView is even created.
  // (Previously this lived inside initWebView; the WebViewController
  // creation + JS injection now happens in onLoadStop below.)
  Future<void> _prepareSession() async {
    _accessToken = await SecureStorageService.getAccessToken();
    _refreshToken = await SecureStorageService.getRefreshToken();
    var userMap = await SecureStorageService.getUser() ?? {};

    if (_accessToken != null && !_isValidPermMap(userMap['permissions'])) {
      userMap = await _withPermissions(userMap, _accessToken!);
    }

    _userJson = jsonEncode(userMap).replaceAll("'", "\\'").replaceAll('\n', '');
    _sessionReady = true;

    if (mounted) setState(() {});
  }

  Future<void> _injectSession(InAppWebViewController c) async {
    await c.evaluateJavascript(source: """
      localStorage.setItem('oji_token', '${_accessToken ?? ''}');
      localStorage.setItem('oji_refresh_token', '${_refreshToken ?? ''}');
      localStorage.setItem('oji_user', '$_userJson');

      var _rk = '$_reloadKey';
      if (!localStorage.getItem(_rk)) {
        localStorage.setItem(_rk, '1');
        window.location.reload();
      } else {
        localStorage.removeItem(_rk);
      }
    """);

    debugPrint("PWA SESSION READY — ${widget.title}");
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Wait until secure storage has been read before mounting the WebView,
    // same gating behaviour as the old `controller == null` check.
    if (!_sessionReady) {
      return const Center(child: CircularProgressIndicator());
    }

    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(widget.url)),
      initialSettings: InAppWebViewSettings(
        javaScriptEnabled: true,
        // Lets the page's own <input type="file"> trigger the native
        // picker; both Android and iOS handle this out of the box.
        useOnDownloadStart: true,
      ),
      onWebViewCreated: (c) => controller = c,
      onLoadStop: (c, url) async => _injectSession(c),
      onReceivedError: (c, request, error) {
        debugPrint("WEB ERROR [${widget.title}] => ${error.description}");
      },
      // Optional: only needed if you want to restrict file types or
      // swap in your own picker UI instead of the OS default on Android.
      // androidOnShowFileChooser: (c, params) async => null,
    );
  }
}