import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class WebView extends StatelessWidget {
  static const routeName = "/web-view";
  WebView({super.key});

  final delegate = NavigationDelegate(
    onNavigationRequest: (request) {
      final url = Uri.parse(request.url);
      url_launcher.launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
      return NavigationDecision.prevent;
    },
  );

  @override
  Widget build(BuildContext context) {
    final WebViewController controller = WebViewController()
      ..setNavigationDelegate(delegate)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..canGoForward()
      ..canGoBack()
      ..loadRequest(
        Uri.parse(ModalRoute.of(context)?.settings.arguments as String),
      );

    return Scaffold(
      appBar: AppBar(),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
