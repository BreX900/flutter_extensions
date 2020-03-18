import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_extensions/flutter_extensions.dart';
import 'package:provider/single_child_widget.dart';

class ChangeableValueBuilder<T extends Listenable, V> extends ChangeableValueConsumerBase<T, V> {
  final bool Function(V before, V after) buildWhen;
  final Widget Function(BuildContext context, T listenable) builder;

  ChangeableValueBuilder({
    T listenable,
    V Function(T listenable) selector,
    this.buildWhen,
    @required this.builder,
  }) : super(listenable: listenable, selector: selector);

  @override
  _ChangeableValueBuilderState<T, V> createState() => _ChangeableValueBuilderState<T, V>();
}

class _ChangeableValueBuilderState<T extends Listenable, V>
    extends _ChangeableValueConsumerBaseState<ChangeableValueBuilder<T, V>, T, V> {
  @override
  void listenChangesValue(V newValue) {
    if ((widget.buildWhen?.call(previousValue, newValue) ?? true)) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, listenable);
}

class ChangeableValueListener<T extends Listenable, V> extends ChangeableValueConsumerBase<T, V> {
  final bool Function(V before, V after) listenWhen;
  final void Function(BuildContext context, T listenable) listener;
  final Widget child;

  ChangeableValueListener({
    T listenable,
    V Function(T listenable) selector,
    this.listenWhen,
    @required this.listener,
    @required this.child,
  }) : super(listenable: listenable, selector: selector);

  @override
  _ChangeableValueListenerState<T, V> createState() => _ChangeableValueListenerState<T, V>();
}

class _ChangeableValueListenerState<T extends Listenable, V>
    extends _ChangeableValueConsumerBaseState<ChangeableValueListener<T, V>, T, V> {
  @override
  void listenChangesValue(V newValue) {
    if (widget.listenWhen?.call(previousValue, newValue) ?? true) {
      widget.listener(context, listenable);
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

abstract class ChangeableValueConsumerBase<T extends Listenable, V>
    extends ChangeableConsumerBase<T> {
  final V Function(T listenable) selector;

  ChangeableValueConsumerBase({
    @required this.selector,
    @required T listenable,
  }) : super(listenable: listenable);
}

abstract class _ChangeableValueConsumerBaseState<W extends ChangeableValueConsumerBase<T, V>,
    T extends Listenable, V> extends ChangeableConsumerBaseState<W, T> {
  V _previousValue;
  V get previousValue => _previousValue;
  V get _selectedValue => listenable != null ? widget.selector(listenable) : null;

  @override
  void subscribe() {
    super.subscribe();
    _previousValue = _selectedValue;
  }

  @override
  void unsubscribe() {
    super.unsubscribe();
    _previousValue = null;
  }

  @override
  void listenChanges() {
    final newValue = _selectedValue;
    if (_previousValue != newValue) listenChangesValue(newValue);
    _previousValue = newValue;
  }

  void listenChangesValue(V oldValue);
}

class ChangeableBuilder<T extends Listenable> extends ChangeableConsumerBase<T> {
  final bool Function(T listenable) buildWhen;
  final Widget Function(BuildContext context, T listenable) builder;

  ChangeableBuilder({
    T listenable,
    this.buildWhen,
    @required this.builder,
  }) : super(listenable: listenable);

  @override
  _ChangeableBuilderState<T> createState() => _ChangeableBuilderState<T>();
}

class _ChangeableBuilderState<T extends Listenable>
    extends ChangeableConsumerBaseState<ChangeableBuilder<T>, T> {
  @override
  void listenChanges() {
    if (widget.buildWhen?.call(listenable) ?? true) setState(() {});
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, listenable);
}

class ChangeableListener<T extends Listenable> extends ChangeableConsumerBase<T> {
  final bool Function(T listenable) listenWhen;
  final void Function(BuildContext context, T listenable) listener;
  final Widget child;

  ChangeableListener({
    T listenable,
    this.listenWhen,
    @required this.listener,
    @required this.child,
  }) : super(listenable: listenable);

  @override
  _ChangeableListenerState<T> createState() => _ChangeableListenerState<T>();
}

class _ChangeableListenerState<T extends Listenable>
    extends ChangeableConsumerBaseState<ChangeableListener<T>, T> {
  @override
  void listenChanges() {
    if (widget.listenWhen?.call(listenable) ?? true) widget.listener(context, listenable);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

abstract class ChangeableConsumerBase<T extends Listenable> extends StatefulWidget {
  final T listenable;

  const ChangeableConsumerBase({Key key, @required this.listenable}) : super(key: key);
}

abstract class ChangeableConsumerBaseState<W extends ChangeableConsumerBase<T>,
    T extends Listenable> extends State<W> {
  T _listenable;
  T get listenable => _listenable;

  @override
  void initState() {
    super.initState();
    _listenable = widget.listenable ?? ChangeableProvider.of<T>(context);
    subscribe();
  }

  @override
  void didUpdateWidget(W oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldState = oldWidget.listenable ?? ChangeableProvider.of<T>(context);
    final currentState = widget.listenable ?? oldState;
    if (currentState != oldState) {
      unsubscribe();
      _listenable = widget.listenable ?? ChangeableProvider.of<T>(context);
      subscribe();
    }
  }

  @override
  void dispose() {
    unsubscribe();
    super.dispose();
  }

  void subscribe() {
    if (_listenable != null) _listenable.addListener(listenChanges);
  }

  void unsubscribe() {
    if (_listenable != null) _listenable.removeListener(listenChanges);
  }

  void listenChanges();
}

class ChangeableProvider<T extends ChangeNotifier> extends SingleChildStatelessWidget {
  final Create<T> create;
  final Dispose<T> dispose;

  ChangeableProvider({
    Key key,
    @required this.create,
    Widget child,
  })  : dispose = ((context, changeNotifier) => changeNotifier.dispose()),
        super(key: key, child: child);

  ChangeableProvider.value({
    Key key,
    @required T listenable,
    Widget child,
  })  : create = ((context) => listenable),
        dispose = null,
        super(key: key, child: child);

  static T of<T>(BuildContext context) => Provider.of<T>(context, listen: false);

  @override
  Widget buildWithChild(BuildContext context, Widget child) {
    return InheritedProvider(
      create: create,
      dispose: dispose,
      child: child,
    );
  }
}
