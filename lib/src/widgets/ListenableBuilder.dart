import 'package:flutter/widgets.dart';
import 'package:flutter_extensions/flutter_extensions.dart';

class ValueListenableBuilder<T extends Listenable, V> extends ListenableConsumerBase<T> {
  final V Function(BuildContext context, T listenable) selector;
  final bool Function(V before, V after) condition;
  final Widget Function(BuildContext context, T listenable) builder;

  ValueListenableBuilder({
    T listenable,
    @required this.selector,
    this.condition,
    @required this.builder,
  }) : super(listenable: listenable);

  @override
  _ValueListenableBuilderState<T, V> createState() => _ValueListenableBuilderState<T, V>();
}

class _ValueListenableBuilderState<T extends Listenable, V>
    extends ListenableConsumerBaseState<ValueListenableBuilder<T, V>, T> {
  V _value;

  @override
  void updateListenable(T newListenable) {
    super.updateListenable(newListenable);
    _value = widget.selector(context, newListenable);
  }

  @override
  void updateState() {
    final newValue = widget.selector(context, listenable);
    if (_value != newValue || (widget.condition != null && widget.condition(_value, newValue))) {
      setState(() {
        _value = newValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, listenable);
  }
}

class ListenableBuilder<T extends Listenable> extends ListenableConsumerBase<T> {
  final Widget Function(BuildContext context, T listenable) builder;

  ListenableBuilder({T listenable, @required this.builder}) : super(listenable: listenable);

  @override
  _ListenableBuilderState<T> createState() => _ListenableBuilderState<T>();
}

class _ListenableBuilderState<T extends Listenable>
    extends ListenableConsumerBaseState<ListenableBuilder<T>, T> {
  @override
  void updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, listenable);
  }
}

abstract class ListenableConsumerBase<T extends Listenable> extends StatefulWidget {
  final T listenable;

  const ListenableConsumerBase({Key key, this.listenable}) : super(key: key);
}

abstract class ListenableConsumerBaseState<W extends ListenableConsumerBase<T>,
    T extends Listenable> extends State<W> {
  T _listenable;
  T get listenable => _listenable;

  @override
  void initState() {
    super.initState();
    updateListenable(widget.listenable);
  }

  @override
  void didUpdateWidget(W oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateListenable(widget.listenable);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_listenable != null && widget.listenable != null) return;
    final newListenable = Provider.of<T>(context, listen: false);
    updateListenable(newListenable);
  }

  @override
  void dispose() {
    updateListenable(null);
    super.dispose();
  }

  void updateListenable(T newListenable) {
    if (_listenable == newListenable) return;
    _listenable?.removeListener(updateState);
    _listenable = newListenable;
    _listenable?.addListener(updateState);
  }

  void updateState();
}
