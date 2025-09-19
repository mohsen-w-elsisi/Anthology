import 'package:anthology_common/article_brief/entities.dart';
import 'package:anthology_common/highlight/entities.dart';

class HighlightFactory {
  final String _textSelection;
  final ArticleBrief _brief;

  HighlightFactory({
    required String textSelection,
    required ArticleBrief brief,
  }) : _textSelection = textSelection,
       _brief = brief;

  // TODO: selecting a non-unique substring within the brief will not guarentee valid start/end index
  Highlight create() => Highlight(
    text: _textSelection,
    articleId: _brief.articleId,
    startIndex: _textStartIndex,
    endIndex: _textEndIndex,
    id: DateTime.now().toString(),
  );

  int get _textStartIndex {
    return _brief.text.indexOf(_textSelection);
  }

  int get _textEndIndex => _textStartIndex + _textSelection.length;
}
