import 'package:flutter/material.dart';

class AnimatedStack extends StatefulWidget {
  final Duration duration;
  final Map<Object, Widget> children;

  const AnimatedStack({Key key, this.duration, this.children}) : super(key: key);

  @override
  _AnimatedStackState createState() => _AnimatedStackState();
}

class _AnimatedStackState extends State<AnimatedStack> with TickerProviderStateMixin {
  List<_Entry> _animations;
  Map<Object, _Entry> _entries = {};

  @override
  void initState() {
    super.initState();
    _update(widget.children);
  }

  @override
  void didUpdateWidget(AnimatedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    _update(oldWidget.children);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _update(Map<Object, Widget> newChildren) {
    final newController = AnimationController(duration: widget.duration, vsync: this);
    final oldController = AnimationController(duration: widget.duration, vsync: this);
    final oldKeys = newChildren.keys.toList();
    final newKeys = widget.children.keys.toList();
    final newEntries = <Object, _Entry>{};
    final removeKeys = <Object>{};
    _Entry newKey;
    _Entry oldKey;
    var i = 0;
    do {
      newKey = newKeys.length < i ? newKeys[i] : null;
      oldKey = oldKeys.length < i ? oldKeys[i] : null;
      i++;
      if (newKey == oldKey) {
        newEntries[newKey] = _entries[newKey]..child = widget.children[newKey];
      } else {
        // vecchio
        if (oldKey != null && !newKeys.contains(oldKey)) {
          newEntries[oldKey] = _entries[oldKey]..controller = oldController;
          removeKeys.add(oldKey);
        }
        // nuovo
        if (newKey != null) {
          newEntries[newKey] = (_entries[newKey] ?? _Entry(newController, null))
            ..child = widget.children[newKey];
        }
      }
    } while (newKey != null || oldKey != null);
    setState(() {
      _entries = newEntries;
      newController.forward();
      oldController.reverse().whenComplete(() {
        setState(() {
          for (var key in newChildren.keys) {
            if (_entries.containsKey(key)) continue;
            _entries.remove(key);
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: _animations.map((entry) {
        return AnimatedBuilder(
          animation: entry.controller,
          child: entry.child,
          builder: (context, child) => Opacity(
            opacity: entry.controller.value,
            child: child,
          ),
        );
      }).toList(),
    );
  }
}

class _Entry {
  AnimationController controller;
  Widget child;

  _Entry(this.controller, this.child);
}

class AnimatedOpacityEnter extends StatefulWidget {
  final Duration duration;
  final Widget child;

  const AnimatedOpacityEnter({
    Key key,
    this.duration = const Duration(milliseconds: 300),
    @required this.child,
  }) : super(key: key);

  @override
  _AnimatedOpacityEnterState createState() => _AnimatedOpacityEnterState();
}

class _AnimatedOpacityEnterState extends State<AnimatedOpacityEnter> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _isVisible ? 1.0 : 0.0,
      duration: widget.duration,
      child: widget.child,
    );
  }
}
