class ReaderScreenSettings {
  final bool isModal;
  final ScrollDestination scrollDestination;

  const ReaderScreenSettings({
    this.isModal = false,
    required this.scrollDestination,
  });

  ReaderScreenSettings copyWith({
    bool? isModal,
    ScrollDestination? scrollDestination,
  }) => ReaderScreenSettings(
    isModal: isModal ?? this.isModal,
    scrollDestination: scrollDestination ?? this.scrollDestination,
  );
}

sealed class ScrollDestination {
  const ScrollDestination();
}

class BeginningDestination extends ScrollDestination {
  const BeginningDestination();
}

class ReaderProgressDestination extends ScrollDestination {
  const ReaderProgressDestination();
}

class TextNodeDestination extends ScrollDestination {
  const TextNodeDestination({required this.index});

  final int index;
}
