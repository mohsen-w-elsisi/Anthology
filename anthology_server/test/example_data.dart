import 'package:anthology_common/article/entities.dart';
import 'package:anthology_common/highlight/entities.dart';

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

  static final highlight1 = Highlight(
    id: 'example-1/1',
    articleId: 'example-1',
    text: 'T',
    startIndex: 0,
    endIndex: 0,
  );

  static final highlight2 = Highlight(
    id: 'example-1/2',
    articleId: 'example-1',
    text: 'domain is for use',
    startIndex: 5,
    endIndex: 21,
  );

  static final highlight3 = Highlight(
    id: 'example-2/1',
    articleId: 'example-2',
    text: 'hi',
    startIndex: 1,
    endIndex: 2,
  );
}
