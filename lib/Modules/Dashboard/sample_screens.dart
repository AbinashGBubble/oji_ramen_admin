import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class UserWebViewPage extends StatelessWidget {
  final String url;

  const UserWebViewPage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(
      controller: WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(Uri.parse(url)),
    );
  }
}
