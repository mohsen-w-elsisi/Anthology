import 'package:anthology_common/article/entities.dart';
import 'package:anthology_common/highlight/data_gateway.dart';
import 'package:anthology_ui/state/reader_view_status_notifier.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../data/article_presentation_meta_data/fetcher.dart';

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
            onTap: _openReaderScreen,
            title: Text(_metaDataFetcher.metaData.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DescribtorText(article: widget.article),
                const SizedBox(height: 8),
                _tagChips,
              ],
            ),
            trailing: _image(),
          ),
        );
      },
    );
  }

  Widget? _image() {
    if (_metaDataFetcher.metaData.image == null) {
      return null;
    } else {
      return SizedBox.square(
        dimension: 200,
        child: Image.network(
          alignment: Alignment.center,
          _metaDataFetcher.metaData.image!,
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
    GetIt.I<ReaderViewStatusNotifier>().setActiveArticle(widget.article);
  }
}

class _DescribtorText extends StatelessWidget {
  final Article article;

  const _DescribtorText({required this.article});

  @override
  Widget build(BuildContext context) {
    return Text("$_publisher • $_progress");
  }

  String get _publisher => article.uri.host;

  String get _progress => "${(article.progress * 100).toInt()}%";
}
