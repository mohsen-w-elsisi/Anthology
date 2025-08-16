import 'package:anthology_common/article/data_gaetway.dart';
import 'package:anthology_common/article/entities.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class NewSaveModal extends StatefulWidget {
  const NewSaveModal({super.key});

  void show(BuildContext context) {
    final isExpanded = MediaQuery.of(context).size.width > 600;
    if (!isExpanded) {
      showModalBottomSheet(
        context: context,
        builder: (_) => this,
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => Dialog(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: this,
          ),
        ),
      );
    }
  }

  @override
  State<NewSaveModal> createState() => _NewSaveModalState();
}

class _NewSaveModalState extends State<NewSaveModal> {
  final _controller = TextEditingController();
  bool _showInvalidUriText = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _contentPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _textField,
          if (_showInvalidUriText) invalidrlText,
          const SizedBox(height: 16),
          _submitButton,
        ],
      ),
    );
  }

  EdgeInsets get _contentPadding {
    return EdgeInsets.only(
      top: 24,
      left: 24,
      right: 24,
      bottom: MediaQuery.of(context).viewInsets.bottom + 24,
    );
  }

  Widget get _textField => TextField(
    controller: _controller,
    autofocus: true,
    decoration: const InputDecoration(
      labelText: 'Article URL',
      hintText: 'https://example.com/article',
    ),
    onSubmitted: (_) => _submit(),
  );

  Widget get invalidrlText => Text(
    'Please enter a valid URL',
    style: TextStyle(color: Theme.of(context).colorScheme.error),
  );

  Widget get _submitButton => FilledButton(
    onPressed: _submit,
    child: const Text('Save'),
  );

  void _submit() {
    final inputText = _controller.text.trim();
    final urlRegex = RegExp(
      r'^(https?|ftp)://[^\s/$.?#].[^\s]*$',
      caseSensitive: false,
    );
    if (urlRegex.hasMatch(inputText)) {
      final article = Article(
        uri: Uri.parse(inputText),
        id: DateTime.now().toIso8601String(),
        tags: {},
        dateSaved: DateTime.now(),
        read: false,
      );
      GetIt.I<ArticleDataGaetway>().save(article);
      Navigator.pop(context);
    } else {
      setState(() => _showInvalidUriText = true);
    }
  }
}
