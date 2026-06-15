import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

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
  WebViewController? controller;

  @override
  bool get wantKeepAlive => true;

  String get _reloadKey =>
      '__flutter_reloaded_${widget.title.replaceAll(' ', '_').toLowerCase()}';

  @override
  void initState() {
    super.initState();
    initWebView();
  }

  // ← NEW: called by CommonBottomBar when Home tab is tapped
  Future<void> reloadToHome() async {
    if (controller == null) return;
    await controller!.loadRequest(Uri.parse(widget.url));
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

  Future<void> initWebView() async {
    final accessToken = await SecureStorageService.getAccessToken();
    final refreshToken = await SecureStorageService.getRefreshToken();
    var userMap = await SecureStorageService.getUser() ?? {};

    if (accessToken != null && !_isValidPermMap(userMap['permissions'])) {
      userMap = await _withPermissions(userMap, accessToken);
    }

    final userJson =
        jsonEncode(userMap).replaceAll("'", "\\'").replaceAll('\n', '');

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) async {
            await controller!.runJavaScript("""
              localStorage.setItem('oji_token', '${accessToken ?? ''}');
              localStorage.setItem('oji_refresh_token', '${refreshToken ?? ''}');
              localStorage.setItem('oji_user', '$userJson');

              var _rk = '$_reloadKey';
              if (!localStorage.getItem(_rk)) {
                localStorage.setItem(_rk, '1');
                window.location.reload();
              } else {
                localStorage.removeItem(_rk);
              }
            """);

            debugPrint("PWA SESSION READY — ${widget.title}");
          },
          onWebResourceError: (error) {
            debugPrint("WEB ERROR [${widget.title}] => ${error.description}");
          },
        ),
      );

    await controller!.loadRequest(Uri.parse(widget.url));

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return controller == null
        ? const Center(child: CircularProgressIndicator())
        : WebViewWidget(controller: controller!);
  }
}