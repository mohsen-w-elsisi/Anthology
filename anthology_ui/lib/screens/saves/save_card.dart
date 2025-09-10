import 'package:anthology_common/article/entities.dart';
import 'package:anthology_ui/state/reader_view_status_notifier.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../data/article_presentation_meta_data/fetcher.dart';

class SaveTile extends StatefulWidget {
  final Article article;

  const SaveTile(this.article, {super.key});

  @override
  State<SaveTile> createState() => _SaveTileState();
}

class _SaveTileState extends State<SaveTile> {
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
        return ListTile(
          onTap: _openReaderScreen,
          leading: _image(),
          title: Text(
            _metaDataFetcher.metaData.title,
            style: TextStyle(fontWeight: _titleFontWeight),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DescribtorText(article: widget.article),
              const SizedBox(height: 8),
              _tagChips,
            ],
          ),
          trailing: PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                child: Text('Delete'),
              ),
              const PopupMenuItem(
                child: Text('Edit Tags'),
              ),
              const PopupMenuItem(
                child: Text('Share'),
              ),
            ],
          ),
        );
      },
    );
  }

  FontWeight get _titleFontWeight {
    return widget.article.progress == 0 ? FontWeight.bold : FontWeight.normal;
  }

  Widget _image() {
    final hasImage = _metaDataFetcher.metaData.image != null;
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: hasImage
            ? Image.network(
                _metaDataFetcher.metaData.image!,
                alignment: Alignment.center,
                fit: BoxFit.cover,
              )
            : Container(color: ColorScheme.of(context).surface),
      ),
    );
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
