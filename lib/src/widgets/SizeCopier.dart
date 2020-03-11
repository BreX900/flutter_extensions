import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class GlobalKeyDrainer<T extends State<StatefulWidget>> extends StatefulWidget {
  final Widget Function(BuildContext, GlobalKey<T>) builder;

  const GlobalKeyDrainer({Key key, @required this.builder}) : super(key: key);

  @override
  _GlobalKeyDrainerState<T> createState() => _GlobalKeyDrainerState<T>();

  static GlobalKey<T> of<T extends State<StatefulWidget>>(BuildContext context) {
    return context.findAncestorStateOfType<_GlobalKeyDrainerState<T>>()._originalKey;
  }
}

class _GlobalKeyDrainerState<T extends State<StatefulWidget>> extends State<GlobalKeyDrainer<T>> {
  GlobalKey<T> _originalKey;

  @override
  void initState() {
    super.initState();
    _originalKey = GlobalKey<T>();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _originalKey);
  }
}

abstract class SizeCopierBinders {
  SizeCopierBinders._();

  static BoxConstraints tight(Size size) {
    return BoxConstraints(minWidth: size.width, minHeight: size.height);
  }

  static BoxConstraints identical(Size size) {
    return BoxConstraints(
      minWidth: size.width,
      maxWidth: size.width,
      minHeight: size.height,
      maxHeight: size.height,
    );
  }

  static BoxConstraints loose(Size size) {
    return BoxConstraints(maxWidth: size.width, maxHeight: size.height);
  }
}

class SizeCopier extends StatefulWidget {
  final bool isRequiredRenderBox;
  final Size initialSize;
  final GlobalKey originalKey;
  final Widget Function(BuildContext, Size) builder;

  SizeCopier({
    Key key,
    bool isRequiredRenderBox = true,
    Size initialSize,
    @required GlobalKey originalKey,
    BoxConstraints Function(Size) binder = SizeCopierBinders.identical,
    Widget Function(BuildContext, Widget) builder,
    Widget child,
  }) : this.custom(
          key: key,
          isRequiredRenderBox: isRequiredRenderBox,
          initialSize: initialSize,
          originalKey: originalKey,
          builder: (context, size) {
            final copy = ConstrainedBox(constraints: binder(size), child: child);
            if (builder != null) return builder(context, copy);
            return copy;
          },
        );

  const SizeCopier.custom({
    Key key,
    this.isRequiredRenderBox = true,
    this.initialSize,
    @required this.originalKey,
    @required this.builder,
  })  : assert(originalKey != null),
        assert(builder != null),
        super(key: key);

  @override
  _SizeCopierState createState() => _SizeCopierState();
}

class _SizeCopierState extends State<SizeCopier> {
  Size _size;

  GlobalKey get originalKey => widget.originalKey;

  @override
  void initState() {
    super.initState();
    _size = widget.initialSize ?? Size.zero;
  }

  void _copySize() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final keyContext = originalKey.currentContext;
      if (keyContext == null) {
        assert(!widget.isRequiredRenderBox, 'Must have [RenderBox]');
        return;
      }
      final box = keyContext.findRenderObject() as RenderBox;
      if (_size != box.size) {
        setState(() {
          _size = box.size;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _copySize();
    return widget.builder(context, _size);
  }
}
