import 'package:flutter/widgets.dart';
import 'package:flutter_extensions/src/dart/MapExt.dart';
import 'package:flutter_extensions/src/widgets/widget_child.dart';
import 'package:provider/provider.dart';

/// Beta
class FocusDispatcher {
  Map<Object, FocusNode> _focusNodes;

  FocusDispatcher([Map<Object, FocusNode> focusNodes]) : _focusNodes = focusNodes ?? {};

  FocusNode operator [](Object key) => _focusNodes[key];

  void operator []=(Object key, FocusNode focusNode) => _focusNodes[key] = focusNode;

  FocusNode get(Object key) => _focusNodes[key];

  FocusNode getNext(Object key) => _focusNodes[_focusNodes.getKeyAfter(key)];

  FocusNode putIfAbsent(
    Object key, {
    String debugLabel,
    FocusOnKeyCallback onKey,
    bool skipTraversal = false,
    bool canRequestFocus = true,
  }) =>
      _focusNodes.putIfAbsent(
          key,
          () => FocusNode(
                debugLabel: debugLabel ?? '$key',
                onKey: onKey,
                skipTraversal: skipTraversal,
                canRequestFocus: canRequestFocus,
              ));

  void add(
    Object key, {
    String debugLabel,
    FocusOnKeyCallback onKey,
    bool skipTraversal = false,
    bool canRequestFocus = true,
  }) =>
      _focusNodes[key] = FocusNode(
        debugLabel: debugLabel ?? '$key',
        onKey: onKey,
        skipTraversal: skipTraversal,
        canRequestFocus: canRequestFocus,
      );

  void addAll(Map<Object, FocusNode> other) => _focusNodes.addAll(other);

  FocusNode remove(Object key) => _focusNodes.remove(key);

  void clear() {
    for (var focusNode in _focusNodes.values) {
      focusNode.dispose();
    }
  }

  void dispose() {
    clear();
    _focusNodes = null;
  }
}

/// Beta
class FocusDispatcherProvider extends Provider<FocusDispatcher> {
  FocusDispatcherProvider({
    @required Create<FocusDispatcher> create,
    Widget child,
  }) : super(
          create: create,
          dispose: (context, dispatcher) => dispatcher.dispose(),
          child: child,
        );

  FocusDispatcherProvider.value({
    @required FocusDispatcher value,
    Widget child,
  }) : super.value(value: value, child: child);

  static FocusDispatcher of(BuildContext context) => Provider.of<FocusDispatcher>(context, listen: false);
}

/// Beta
mixin NestedFocusDispatcher on NestedChild {
  FocusDispatcher onCreateFocusDispatcher(BuildContext context) => FocusDispatcher();

  Widget buildWithChild(BuildContext context, Widget child) {
    return FocusDispatcherProvider(
      create: onCreateFocusDispatcher,
      child: super.buildWithChild(context, child),
    );
  }

  FocusDispatcher focusDispatcherOf(BuildContext context) =>
      Provider.of<FocusDispatcher>(context, listen: false);
}

abstract class EffectiveFocusNode extends StatefulWidget {
  final FocusNode focusNode;

  const EffectiveFocusNode({Key key, this.focusNode}) : super(key: key);
}

mixin EffectiveFocusNodeMixin<W extends EffectiveFocusNode> on State<W> {
  FocusNode _focusNode;
  FocusNode get effectiveFocusNode => widget.focusNode ?? (_focusNode ??= FocusNode());
}

mixin ListenEffectiveFocusNodeMixin<W extends EffectiveFocusNode> on EffectiveFocusNodeMixin<W> {
  @override
  void initState() {
    super.initState();
    effectiveFocusNode.addListener(onFocusNodeChange);
  }

  @override
  void didUpdateWidget(W oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      (oldWidget.focusNode ?? _focusNode).removeListener(onFocusNodeChange);
      effectiveFocusNode.addListener(onFocusNodeChange);
    }
  }

  @override
  void dispose() {
    effectiveFocusNode.removeListener(onFocusNodeChange);
    super.dispose();
  }

  void onFocusNodeChange() {}
}

mixin ListenEffectiveFocusMixin<W extends EffectiveFocusNode> on ListenEffectiveFocusNodeMixin<W> {
  bool _hasFocus;
  bool get hasFocus => _hasFocus;

  @override
  void initState() {
    super.initState();
    _hasFocus = effectiveFocusNode.hasFocus;
  }

  @override
  void onFocusNodeChange() {
    super.onFocusNodeChange();
    if (_hasFocus != effectiveFocusNode.hasFocus) {
      _hasFocus = effectiveFocusNode.hasFocus;
      onFocusChange();
    }
  }

  void onFocusChange() {}
}
