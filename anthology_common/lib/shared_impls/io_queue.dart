import 'dart:async';

mixin IoQueue {
  Future<void> _lastOperation = Future.value();

  Future<T> queueUp<T>(Future<T> Function() operation) {
    final result = _lastOperation.then((_) => operation());
    _lastOperation = result;
    return result;
  }
}
