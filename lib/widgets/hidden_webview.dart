import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class HiddenWebView extends StatelessWidget {
  final String url;
  final Function(String) onHtmlLoaded;

  const HiddenWebView({
    super.key,
    required this.url,
    required this.onHtmlLoaded,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0,
      child: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(url)),
        initialSettings: InAppWebViewSettings(
          userAgent:
              "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36",
          javaScriptEnabled: true,
          domStorageEnabled: true,
        ),
        onLoadStop: (controller, url) async {
          await Future.delayed(const Duration(seconds: 4));

          final html = await controller.getHtml();
          if (html != null) {
            onHtmlLoaded(html);
          }
        },
      ),
    );
  }
}
