import 'dart:async';
import 'package:anthology_common/article_brief/generator.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ReadabilityArticleBriefGenerator extends ArticleBriefHtmlGenerator {
  static late final String readabilityJs;

  static Future<void> init() async {
    readabilityJs = await rootBundle.loadString('assets/Readability.js');
  }

  late final HeadlessInAppWebView _webView;
  final _completer = Completer<CrudeArticleBrief>();

  ReadabilityArticleBriefGenerator(super.article);

  @override
  Future<CrudeArticleBrief> generate() async {
    _initWebView();
    await _webView.run();
    try {
      final brief = await _completer.future;
      return brief;
    } catch (e) {
      rethrow;
    } finally {
      await _webView.dispose();
    }
  }

  void _initWebView() {
    _webView = HeadlessInAppWebView(
      initialUrlRequest: _articleUrlRequest,
      onWebViewCreated: (controller) {
        controller.addJavaScriptHandler(
          handlerName: 'articleParsed',
          callback: (args) {
            if (_completer.isCompleted) return;
            try {
              final result = Map<String, dynamic>.from(args[0]);
              final crudeBrief = CrudeArticleBrief(
                title: result["title"]?.toString() ?? "Untitled",
                htmlContent: result["content"]?.toString() ?? "",
                byline: result["byline"]?.toString() ?? "",
              );
              _completer.complete(crudeBrief);
            } catch (e, s) {
              _completer.completeError(e, s);
            }
          },
        );
        controller.addJavaScriptHandler(
          handlerName: 'parseFailed',
          callback: (args) {
            if (_completer.isCompleted) return;
            _completer.completeError(
              args.isNotEmpty ? args[0] : 'Failed to parse article',
            );
          },
        );
      },
      onLoadStop: (controller, _) => _generate(controller),
      onLoadError: (_, _, _, message) {
        if (!_completer.isCompleted) {
          _completer.completeError('Failed to load URL: $message');
        }
      },
    );
  }

  Future<void> _generate(InAppWebViewController controller) async {
    try {
      await _injectReadabilityJsIntoWebView(controller);
      await _parseInWebView(controller);
    } catch (e) {
      if (!_completer.isCompleted) {
        _completer.completeError(e);
      }
    }
  }

  Future<void> _injectReadabilityJsIntoWebView(
    InAppWebViewController controller,
  ) async {
    await controller.evaluateJavascript(source: readabilityJs);
  }

  Future<void> _parseInWebView(InAppWebViewController controller) async {
    await controller.evaluateJavascript(
      source: '''
      try {
        const article = new Readability(document.cloneNode(true)).parse();
        if (article) {
          window.flutter_inappwebview.callHandler('articleParsed', article);
        } else {
          window.flutter_inappwebview.callHandler('parseFailed', 'Readability.parse() returned null');
        }
      } catch (e) {
        window.flutter_inappwebview.callHandler('parseFailed', e.toString());
      }
    ''',
    );
  }

  URLRequest get _articleUrlRequest =>
      URLRequest(url: WebUri(article.uri.toString()));
}
