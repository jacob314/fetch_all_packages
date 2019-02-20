import 'dart:async';

import 'package:flutter/services.dart';

class MarkdownOption {
  static const int Markdown = 1;
  static const int Github = 2;
  static const int MarkdownExtra = 3;
  static const int MultiMarkdown = 4;
}

class HtmlToMarkdown {
  static const MethodChannel _channel = const MethodChannel('html_to_markdown');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> convert(String html, option) async {
    final String version = await _channel
        .invokeMethod("convert", {"html": html, "markdown_type": option});
    return version;
  }
}
