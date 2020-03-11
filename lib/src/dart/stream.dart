import 'dart:async';

import 'package:rxdart/rxdart.dart';
// ignore: implementation_imports
import 'package:rxdart/src/transformers/backpressure/backpressure.dart';

extension StreamDartExt<T> on Stream<T> {
  Stream<T> distinctType() => distinct((bef, aft) => bef.runtimeType == aft.runtimeType);
  Stream<T> dumpErrorToConsoleDart() => doOnError((error, stackTrace) {
        print(error);
        print(stackTrace);
      });

  Stream<List<T>> bufferWithTimer(Duration duration, {bool ignoreEmpty = true}) =>
      advBuffer((_) => TimerStream<bool>(true, duration), ignoreEmpty: ignoreEmpty);

  Stream<List<T>> advBuffer(
    Stream<dynamic> Function(T event) streamFactory, {
    WindowStrategy strategy = WindowStrategy.everyEvent,
    bool ignoreEmpty = true,
  }) =>
      transform(BackpressureStreamTransformer(
        strategy,
        streamFactory,
        onWindowEnd: (queue) => queue,
        ignoreEmptyWindows: ignoreEmpty,
      ));

  Stream<T> advDebounce(
    Stream<dynamic> Function(T event) streamFactory, {
    WindowStrategy strategy = WindowStrategy.everyEvent,
    bool ignoreEmpty = true,
  }) =>
      transform(BackpressureStreamTransformer(
        strategy,
        streamFactory,
        onWindowEnd: (queue) => queue.last,
        ignoreEmptyWindows: ignoreEmpty,
      ));
}

extension FutureDartExt<T> on Future<T> {
  Future<T> dumpErrorToConsoleDart() => catchError((error, stackTrace) {
        print(error);
        print(stackTrace);
      });
}

class CompositeMapSubscription {
  bool _isDisposed = false;
  bool get isDisposed => _isDisposed;

  final _subscriptions = <Object, StreamSubscription<dynamic>>{};

  StreamSubscription<T> add<T>(Object key, StreamSubscription<T> subscription) {
    if (isDisposed) {
      throw ('This composite was disposed, try to use new instance instead');
    }
    _subscriptions[key] = subscription;
    return subscription;
  }

  StreamSubscription<T> putIfAbsent<T>(Object key, StreamSubscription<T> Function() ifAbsent) {
    if (isDisposed) {
      throw ('This composite was disposed, try to use new instance instead');
    }
    return _subscriptions.putIfAbsent(key, ifAbsent);
  }

  StreamSubscription<T> get<T>(Object key) => _subscriptions[key];

  bool containsKey(Object key) => _subscriptions.containsKey(key);

  bool containsSubscription(StreamSubscription subscription) =>
      _subscriptions.containsValue(subscription);

  Future<dynamic> remove(Object key) => _subscriptions.remove(key)?.cancel();

  Future<void> clear() {
    final result = Future.wait(_subscriptions.values.map((subscription) => subscription.cancel()));
    _subscriptions.clear();
    return result;
  }

  Future<void> dispose() {
    final result = clear();
    _isDisposed = true;
    return result;
  }
}
