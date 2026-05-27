import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:loyalty_admin/services/storage/secure_storage_service.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() =>
      _AnalyticsScreenState();
}

class _AnalyticsScreenState
    extends State<AnalyticsScreen> {

  WebViewController? controller;

  @override
  void initState() {
    super.initState();
    initWebView();
  }

  Future<void> initWebView() async {

    final accessToken =
      await SecureStorageService.getAccessToken();

    final refreshToken =
      await SecureStorageService.getRefreshToken();

    final cookieManager =
      WebViewCookieManager();

    // clear old session
    await cookieManager.clearCookies();

    // set cookies
    await cookieManager.setCookie(
      WebViewCookie(
        name: 'oji_token',
        value: accessToken ?? '',
        domain:
        'master.d1qi4h2imco1od.amplifyapp.com',
      ),
    );

    await cookieManager.setCookie(
      WebViewCookie(
        name: 'oji_refresh_token',
        value: refreshToken ?? '',
        domain:
        'master.d1qi4h2imco1od.amplifyapp.com',
      ),
    );

    controller = WebViewController()

      ..setJavaScriptMode(
        JavaScriptMode.unrestricted,
      )

      ..setNavigationDelegate(
        NavigationDelegate(

          onPageFinished: (url)
          async {

            // also keep localStorage
            await controller!
            .runJavaScript("""

            localStorage.setItem(
            'oji_token',
            '$accessToken'
            );

            localStorage.setItem(
            'oji_refresh_token',
            '$refreshToken'
            );

            """);

            debugPrint(
            "SESSION READY"
            );

          },

          onWebResourceError:
          (error){

            debugPrint(
            "WEB ERROR => "
            "${error.description}"
            );

          },
        ),
      );

    await controller!.loadRequest(
      Uri.parse(
      "https://master.d1qi4h2imco1od.amplifyapp.com/analytics"
      ),
    );

    if(mounted){
      setState(() {});
    }
  }

  @override
  Widget build(
      BuildContext context){

    return Scaffold(
      appBar: AppBar(
        title:
        const Text(
        "Analytics"
        ),
      ),
      body:
      controller==null
      ? const Center(
        child:
        CircularProgressIndicator(),
      )
      : WebViewWidget(
          controller:
          controller!,
        ),
    );
  }
}