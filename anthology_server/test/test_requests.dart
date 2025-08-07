import 'dart:convert';

import 'package:anthology_common/article/entities.dart';
import 'package:http/http.dart';

import 'basic_http_requests.dart';
import 'example_data.dart';

class TestRequests {
  final BasicHttpRequests baseRequests;

  TestRequests(this.baseRequests);

  Future<Response> getArticle1() {
    return baseRequests.getArticle(ExampleData.article1.id);
  }

  Future<Article> getArticle1AsArticle() async {
    final res = await getArticle1();
    return Article.fromJson(jsonDecode(res.body));
  }

  Future<Response> saveArticle1() {
    return baseRequests.postArticle(ExampleData.article1);
  }

  Future<Response> saveArticle2() {
    return baseRequests.postArticle(ExampleData.article2);
  }

  Future<Response> deleteArticle1() {
    return baseRequests.deleteArticle(ExampleData.article1.id);
  }

  Future<Response> markArticle1Read() {
    return baseRequests.markRead(ExampleData.article1.id);
  }

  Future<Response> markArticle1Unread() {
    return baseRequests.markUnread(ExampleData.article1.id);
  }
}
