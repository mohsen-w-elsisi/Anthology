import 'dart:async';
import 'dart:io';

import 'package:anthology_ui/screens/saves/new_save_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sharing_intent/flutter_sharing_intent.dart';
import 'package:flutter_sharing_intent/model/sharing_file.dart';

mixin ShareIntentHandlerMixin<T extends StatefulWidget> on State<T> {
  StreamSubscription? _intentDataStreamSubscription;

  GlobalKey<NavigatorState> get navigatorKey;

  void initShareIntentHandler() {
    if (Platform.isLinux || Platform.isWindows) return;
    // For sharing or opening urls/text while app is in memory
    _intentDataStreamSubscription = FlutterSharingIntent.instance
        .getMediaStream()
        .listen(_handleSharedUrl);
    // For sharing or opening urls/text while app is closed
    FlutterSharingIntent.instance.getInitialSharing().then(
      _handleSharedUrl,
    );
  }

  void _handleSharedUrl(List<SharedFile> value) {
    if (value.isEmpty) return;
    final sharedUrl = value.first.value;
    final context = navigatorKey.currentContext;
    if (sharedUrl != null && context != null) {
      NewSaveModal(initialUrl: sharedUrl).show(context);
    }
  }

  void cancelShareIntentSubscription() {
    _intentDataStreamSubscription?.cancel();
  }
}
