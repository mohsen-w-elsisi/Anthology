import 'dart:async';

mixin IoQueue {
  Future<void> _lastOperation = Future.value();

  Future<T> queueUp<T>(Future<T> Function() operation) {
    final result = _lastOperation.then((_) => operation());
    // if _lastOperation completed with an error, _lastOperation.then(...) will
    // never run, hence completely halting the queue
    // ignore: body_might_complete_normally_catch_error
    _lastOperation = result.catchError((_) {});
    return result;
  }
}
