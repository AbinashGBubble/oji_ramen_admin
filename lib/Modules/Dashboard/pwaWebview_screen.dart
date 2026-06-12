import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

import 'package:loyalty_admin/services/storage/secure_storage_service.dart';

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

  @override
  void initState() {
    super.initState();
    initWebView();
  }

  Future<void> initWebView() async {
    final accessToken = await SecureStorageService.getAccessToken();
    final refreshToken = await SecureStorageService.getRefreshToken();
    final userMap = await SecureStorageService.getUser();

    final userJson =
        userMap != null ? jsonEncode(userMap).replaceAll("'", "\\'") : '{}';

    final cookieManager = WebViewCookieManager();

    // Clear old cookies
    await cookieManager.clearCookies();

    // Set access token cookie
    await cookieManager.setCookie(
      WebViewCookie(
        name: 'oji_token',
        value: accessToken ?? '',
        domain: 'master.d1qi4h2imco1od.amplifyapp.com',
      ),
    );

    // Set refresh token cookie
    await cookieManager.setCookie(
      WebViewCookie(
        name: 'oji_refresh_token',
        value: refreshToken ?? '',
        domain: 'master.d1qi4h2imco1od.amplifyapp.com',
      ),
    );

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) async {
            await controller!.runJavaScript("""
              localStorage.setItem('oji_token', '$accessToken');
              localStorage.setItem('oji_refresh_token', '$refreshToken');
              localStorage.setItem('oji_user', '$userJson');

              if (!localStorage.getItem('__flutter_reloaded')) {
                localStorage.setItem('__flutter_reloaded', '1');
                window.location.reload();
              } else {
                localStorage.removeItem('__flutter_reloaded');
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

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // super.build required by AutomaticKeepAliveClientMixin
    super.build(context);

    return controller == null
        ? const Center(child: CircularProgressIndicator())
        : WebViewWidget(controller: controller!);
  }
}
