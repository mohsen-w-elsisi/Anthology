import 'package:anthology_common/article/entities.dart';
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
    return FutureBuilder(
      future: _metaDataFetcher.fetch(),
      builder: (_, _) {
        return Card(
          child: ListTile(
            title: Text(_metaDataFetcher.title),
            subtitle: Text("${widget.article.uri.host} • 0 hgihilights"),
            trailing: SizedBox.square(
              dimension: 400,
              child: _image(),
            ),
          ),
        );
      },
    );
  }

  Widget _image() {
    if (_metaDataFetcher.image == null) {
      return Container();
    } else {
      return Image.network(
        _metaDataFetcher.image!,
      );
    }
  }
}
