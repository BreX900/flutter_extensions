import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
// ignore: implementation_imports
import 'package:rxdart/src/transformers/backpressure/backpressure.dart';

extension StreamExtDart<T> on Stream<T> {
  Stream<T> distinctRuntimeType() => distinct((bef, aft) => bef.runtimeType == aft.runtimeType);

  Future<R> firstType<R>({R orElse()}) {
    final completer = Completer<R>();
    firstWhere((v) => v is T).then((v) => completer.complete(v as R), onError: (exception, stackTrace) {
      if (exception is StateError && orElse != null) {
        completer.complete(orElse());
      } else {
        completer.completeError(exception, stackTrace);
      }
    });
    return completer.future;
  }

  Future<R> firstRuntimeType<R>({R orElse()}) {
    final completer = Completer<R>();
    firstWhere((v) => v.runtimeType == T).then((v) => completer.complete(v as R),
        onError: (exception, stackTrace) {
      if (exception is StateError && orElse != null) {
        completer.complete(orElse());
      } else {
        completer.completeError(exception, stackTrace);
      }
    });
    return completer.future;
  }

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

  Stream<R> onChanges<R>({
    bool Function(T, T) equals,
    Duration debounceTime = const Duration(),
    void Function(T data) onStart,
    @required Stream<R> Function(T data) onData,
  }) {
    assert(debounceTime != null, 'debounceTime can\'t be null');
    assert(onData != null, 'onData function is required');

    final _onStart = onStart ?? (T d) {};

    return distinct(equals).skip(1).doOnData(_onStart).debounceTime(debounceTime).switchMap<R>(onData);
  }
}

extension StreamIterableExtDart<T> on Stream<Iterable<T>> {
  Stream<R> onIterableChanges<R>({
    bool Function(Iterable<T> previous, Iterable<T> current) equals,
    Duration debounceTime = const Duration(),
    void Function(Iterable<T> data) onStart,
    @required Stream<R> Function(Iterable<T> previous, Iterable<T> current) onData,
  }) {
    assert(debounceTime != null, 'debounceTime can\'t be null');
    assert(onData != null, 'onData function is required');

    final _onStart = onStart ?? (T d) {};

    return distinct(equals)
        .pairwise()
        .doOnData(_onStart)
        .debounceTime(debounceTime)
        .switchMap<R>((data) => onData(data.first, data.last));
  }
}
//
//@visibleForTesting
//class SeparateStreamTransformer<T> extends StreamTransformerBase<Iterable<T>, SeparatedValues<T>> {
//  SeparateStreamTransformer();
//
//  @override
//  Stream<SeparatedValues<T>> bind(Stream<Iterable<T>> stream) async* {
//    Iterable<T> oldValues = <T>[];
//    await for (var currentValues in stream) {
//      yield SeparatedValues<T>._(
//        currentValues.where((value) => !oldValues.contains(value)).toList(),
//        oldValues.where(currentValues.contains).toList(),
//        oldValues.where((value) => !currentValues.contains(value)).toList(),
//      );
//      oldValues = currentValues;
//    }
//  }
//}
//
//class SeparatedValues<T> {
//  final List<T> newValues;
//  final List<T> sameValues;
//  final List<T> oldValues;
//
//  SeparatedValues._(this.newValues, this.sameValues, this.oldValues);
//
//  @override
//  bool operator ==(Object other) =>
//      identical(this, other) ||
//      other is SeparatedValues &&
//          runtimeType == other.runtimeType &&
//          newValues == other.newValues &&
//          sameValues == other.sameValues &&
//          oldValues == other.oldValues;
//
//  @override
//  int get hashCode => newValues.hashCode ^ sameValues.hashCode ^ oldValues.hashCode;
//}

extension FutureDartExt<T> on Future<T> {
  Future<T> dumpErrorToConsoleDart() => catchError((error, stackTrace) {
        print(error);
        print(stackTrace);
      });
}

class CompositeMapSubscription<K> {
  bool _isDisposed = false;
  bool get isDisposed => _isDisposed;

  final _subscriptions = <K, StreamSubscription<dynamic>>{};

  void _check() {
    if (isDisposed) {
      throw ('This composite was disposed, try to use new instance instead');
    }
  }

  StreamSubscription<T> add<T>(K key, StreamSubscription<T> subscription) {
    _check();
    _subscriptions[key] = subscription;
    return subscription;
  }

  StreamSubscription<T> putIfAbsent<T>(K key, StreamSubscription<T> Function() ifAbsent) {
    _check();
    return _subscriptions.putIfAbsent(key, ifAbsent);
  }

  StreamSubscription<T> get<T>(K key) => _subscriptions[key];

  bool containsKey(K key) => _subscriptions.containsKey(key);

  bool containsSubscription(StreamSubscription subscription) => _subscriptions.containsValue(subscription);

  Future<dynamic> cancel(K key) => _subscriptions.remove(key).cancel();

  Future<dynamic> cancelWhere(bool Function(K key, StreamSubscription subscription) fn) {
    final futures = <Future>[];
    _subscriptions.removeWhere((key, subscription) {
      if (fn(key, subscription)) {
        futures.add(subscription.cancel());
        return true;
      }
      return false;
    });
    return Future.wait(futures);
  }

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

extension SubscriptionCompositeExtension on StreamSubscription {
  void addToByKey<K>(CompositeMapSubscription<K> subscriber, K key) {
    subscriber.add(key, this);
  }
}

class SubjectTransformer<T> extends Subject<T> {
  SubjectTransformer._(StreamController<T> controller, Stream<T> Function(Stream<T> stream) transformer)
      : super(controller, transformer(controller.stream));

  SubjectTransformer.publish(Stream<T> Function(Stream<T> stream) transformer)
      : this._(PublishSubject(), transformer);

  SubjectTransformer.behaviour(Stream<T> Function(Stream<T> stream) transformer)
      : this._(BehaviorSubject(), transformer);

  SubjectTransformer.behaviourSeed(Stream<T> Function(Stream<T> stream) transformer, T seedValue)
      : this._(BehaviorSubject.seeded(seedValue), transformer);

  SubjectTransformer.replay(Stream<T> Function(Stream<T> stream) transformer)
      : this._(ReplaySubject(), transformer);

  @override
  StreamController<T> createForwardingController({
    void Function() onListen,
    void Function() onCancel,
    bool sync = false,
  }) {
    return PublishSubject(
      onListen: onListen,
      onCancel: onCancel,
      sync: sync,
    );
  }
}
