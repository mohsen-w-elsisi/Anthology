import 'package:anthology_ui/screens/reader/reader_screen.dart';
import 'package:anthology_ui/state/reader_view_status_notifier.dart';
import 'package:anthology_ui/utils.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:multi_split_view/multi_split_view.dart';

import 'screens/saves/saves_screen.dart';
import 'shared_widgets/navigation_bar.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final _readerStatusNotifier = GetIt.I<ReaderViewStatusNotifier>();
  bool? _wasExpanded;

  @override
  void initState() {
    super.initState();
    _readerStatusNotifier.addListener(_onReaderStatusChanged);
  }

  @override
  void dispose() {
    _readerStatusNotifier.removeListener(_onReaderStatusChanged);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _handleLayoutChange();
  }

  @override
  Widget build(BuildContext context) {
    if (isExpanded(context)) {
      return Row(
        children: [
          AppNavigationBar.rail(),
          Expanded(
            child: MultiSplitView(
              dividerBuilder: (_, _, _, dragging, highlighted, _) {
                return ResizablePaneDragHandle(
                  isPressed: dragging,
                  isHovered: highlighted,
                );
              },
              initialAreas: [
                Area(builder: (_, _) => const SavesScreen()),
                Area(builder: (_, _) => _readerScreenPane()),
              ],
            ),
          ),
        ],
      );
    } else {
      return const SavesScreen();
    }
  }

  void _handleLayoutChange() {
    final isCurrentlyExpanded = isExpanded(context);
    if (_wasExpanded == true && !isCurrentlyExpanded) {
      _showReaderAsModal();
    } else if (_wasExpanded == false && isCurrentlyExpanded) {
      _popReaderIfModal();
    }
    _wasExpanded = isCurrentlyExpanded;
  }

  void _onReaderStatusChanged() {
    final activeArticle = _readerStatusNotifier.activeArticle;
    if (!isExpanded(context) && activeArticle != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ReaderScreen(activeArticle, isModal: true),
        ),
      );
    }
  }

  void _popReaderIfModal() {
    final readerStatus = GetIt.I<ReaderViewStatusNotifier>();
    if (readerStatus.isReaderModalActive) {
      // cannot retrigger build stage during build stage, hence pop postframe
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.of(context).pop();
        }
      });
    }
  }

  void _showReaderAsModal() {
    final activeArticle = GetIt.I<ReaderViewStatusNotifier>().activeArticle;
    if (activeArticle != null) {
      // cannot retrigger build stage during build stage, hence pop postframe
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ReaderScreen(activeArticle, isModal: true),
            ),
          );
        }
      });
    }
  }

  Widget _readerScreenPane() {
    return ListenableBuilder(
      listenable: GetIt.I<ReaderViewStatusNotifier>(),
      builder: (_, _) {
        final activeArticle = GetIt.I<ReaderViewStatusNotifier>().activeArticle;
        if (activeArticle != null) {
          return ReaderScreen(activeArticle);
        } else {
          return const Scaffold(
            body: Center(
              child: Text("Select an article to begin reading"),
            ),
          );
        }
      },
    );
  }
}

class ResizablePaneDragHandle extends StatelessWidget {
  static const _handleAnimationDuration = Duration(milliseconds: 100);

  final bool isPressed;
  final bool isHovered;

  const ResizablePaneDragHandle({
    super.key,
    required this.isPressed,
    required this.isHovered,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      color: ColorScheme.of(context).surface,
      child: Center(child: _handle(context)),
    );
  }

  Widget _handle(BuildContext context) {
    return AnimatedOpacity(
      duration: _handleAnimationDuration,
      opacity: _handleOpacity,
      child: AnimatedContainer(
        duration: _handleAnimationDuration,
        width: _handleWidth,
        height: _handleHeight,
        decoration: BoxDecoration(
          borderRadius: _handleBorderRadius,
          color: _handleColor(context),
        ),
      ),
    );
  }

  double get _handleOpacity => isHovered && !isPressed ? 0.08 : 1;

  BorderRadius get _handleBorderRadius =>
      BorderRadius.circular(isPressed ? 12 : 4);

  Color _handleColor(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    if (isPressed) {
      return colorScheme.onSurface;
    } else if (isHovered) {
      return colorScheme.onInverseSurface;
    } else {
      return colorScheme.outline;
    }
  }

  double get _handleHeight => isPressed ? 52 : 48;
  double get _handleWidth => isPressed ? 12 : 4;
}
