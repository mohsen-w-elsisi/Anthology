import 'package:anthology_common/article/entities.dart';
import 'package:anthology_ui/screens/reader/reader_screen.dart';
import 'package:flutter/material.dart';

import 'article_presentation_meta_data_fetcher.dart';

class SaveCard extends StatefulWidget {
  final Article article;

  const SaveCard(this.article, {super.key});

  @override
  State<SaveCard> createState() => _SaveCardState();
}

class _SaveCardState extends State<SaveCard> {
  late final ArticlePresentationMetaDataFetcher _metaDataFetcher;

  @override
  void initState() {
    super.initState();
    _metaDataFetcher = ArticlePresentationMetaDataFetcher(widget.article);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openReaderScreen,
      child: FutureBuilder(
        future: _metaDataFetcher.fetch(),
        builder: (_, _) {
          return Card(
            child: ListTile(
              title: Text(_metaDataFetcher.title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${widget.article.uri.host} • 0 hgihilights"),
                  const SizedBox(height: 8),
                  _tagChips,
                ],
              ),
              trailing: _image(),
            ),
          );
        },
      ),
    );
  }

  Widget? _image() {
    if (_metaDataFetcher.image == null) {
      return null;
    } else {
      return SizedBox.square(
        dimension: 200,
        child: Image.network(
          alignment: Alignment.center,
          _metaDataFetcher.image!,
        ),
      );
    }
  }

  Widget get _tagChips => Wrap(
    children: [
      for (final tag in widget.article.tags)
        Chip(
          visualDensity: VisualDensity.compact,
          label: Text(tag),
          labelStyle: Theme.of(context).textTheme.labelSmall,
        ),
    ],
  );

  void _openReaderScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ReaderScreen(widget.article),
      ),
    );
  }
}
