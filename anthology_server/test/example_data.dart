import 'package:anthology_common/article/entities.dart';

class ExampleData {
  static final article1 = Article(
    uri: Uri.http("example.com"),
    id: "example-1",
    tags: {},
    dateSaved: DateTime.now(),
    read: false,
  );

  static final article2 = Article(
    uri: Uri.http("example.com"),
    id: "example-2",
    tags: {},
    dateSaved: DateTime.now(),
    read: false,
  );
}
