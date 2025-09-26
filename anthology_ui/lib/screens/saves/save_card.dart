import 'dart:io';

import 'package:anthology_common/article/entities.dart';
import 'package:anthology_ui/app_actions.dart';
import 'package:anthology_ui/data/article_presentation_meta_data/entities.dart';
import 'package:anthology_ui/screens/reader/reader_screen_settings.dart';
import 'package:anthology_ui/state/reader_view_status_notifier.dart';
import 'package:anthology_ui/data/article_presentation_meta_data/fetcher.dart';
import 'package:anthology_ui/screens/saves/edit_tags_modal.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class SaveTile extends StatefulWidget {
  final Article article;
  final Function()? onDismissed;

  const SaveTile(this.article, {super.key, this.onDismissed});
  @override
  State<SaveTile> createState() => _SaveTileState();
}

class _SaveTileState extends State<SaveTile> {
  late final Future<ArticlePresentationMetaData> _metadataFuture;

  @override
  void initState() {
    super.initState();
    _metadataFuture = ArticlePresentationMetaDataFetcher(
      widget.article,
    ).fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.article.id),
      direction: widget.article.isArchived
          ? DismissDirection.none
          : DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).colorScheme.secondaryContainer,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16.0),
        child: Icon(
          Icons.archive_outlined,
          color: ColorScheme.of(context).onSecondaryContainer,
        ),
      ),
      onDismissed: (_) => widget.onDismissed!(),
      child: ListTile(
        onTap: _openReaderScreen,
        isThreeLine: true,
        leading: FutureBuilder(
          future: _metadataFuture,
          builder: (_, snapshot) => _image(snapshot.data?.image),
        ),
        title: FutureBuilder(
          future: _metadataFuture,
          builder: (_, snapshot) {
            return Text(
              snapshot.data?.title ?? 'Loading...',
              maxLines: widget.article.tags.isEmpty ? 2 : 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: _titleFontWeight),
            );
          },
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DescribtorText(article: widget.article),
            _tagChips,
          ],
        ),
        trailing: _ActionsMenu(widget: widget),
      ),
    );
  }

  FontWeight get _titleFontWeight {
    return widget.article.progress == 0 ? FontWeight.bold : FontWeight.normal;
  }

  Widget _image(String? imageUri) {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: imageUri != null
            ? Image.network(
                imageUri,
                alignment: Alignment.center,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) {
                  return Container(color: ColorScheme.of(context).surface);
                },
              )
            : Container(color: ColorScheme.of(context).surface),
      ),
    );
  }

  Widget get _tagChips => Wrap(
    spacing: 4.0,
    runSpacing: 4.0,
    children: [
      for (final tag in widget.article.tags)
        Chip(
          visualDensity: VisualDensity.compact,
          labelPadding: EdgeInsets.zero,
          label: Text(tag),
          labelStyle: Theme.of(context).textTheme.labelSmall,
        ),
    ],
  );

  void _openReaderScreen() {
    GetIt.I<ReaderViewStatusNotifier>().setActiveArticleWithSettings(
      widget.article,
      const ReaderScreenSettings(
        scrollDestination: ReaderProgressDestination(),
      ),
    );
  }
}

class _ActionsMenu extends StatelessWidget {
  final SaveTile widget;

  const _ActionsMenu({required this.widget});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) => [
        PopupMenuItem(
          onTap: _toggleArchiveStatus,
          child: Text(widget.article.isArchived ? 'Unarchive' : 'Archive'),
        ),
        PopupMenuItem(
          onTap: () => _editTags(context),
          child: Text('Edit Tags'),
        ),
        if (!Platform.isLinux)
          PopupMenuItem(
            onTap: _shareArticle,
            child: Text('Share'),
          ),
        PopupMenuItem(
          onTap: _deleteArticle,
          child: Text('Delete'),
        ),
      ],
    );
  }

  void _deleteArticle() => AppActions.deleteArticle(widget.article.id);
  void _shareArticle() => AppActions.shareArticle(widget.article);
  void _toggleArchiveStatus() {
    AppActions.setArticleArchiveStatus(
      widget.article.id,
      !widget.article.isArchived,
    );
  }

  void _editTags(BuildContext context) {
    EditTagsModal(article: widget.article).show();
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
