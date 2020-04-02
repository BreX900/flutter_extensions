import 'package:flutter/widgets.dart';

class FadeIndexStack extends StatefulWidget {
  final int index;
  final Duration duration;
  final AlignmentGeometry alignment;
  final TextDirection textDirection;
  final StackFit fit;
  final Overflow overflow;
  final List<Widget> children;

  const FadeIndexStack({
    Key key,
    @required this.index,
    this.alignment = AlignmentDirectional.topStart,
    this.textDirection,
    this.fit = StackFit.loose,
    this.overflow = Overflow.clip,
    this.duration = const Duration(milliseconds: 700),
    @required this.children,
  }) : super(key: key);

  @override
  _FadeIndexStackState createState() => _FadeIndexStackState();
}

class _FadeIndexStackState extends State<FadeIndexStack> with TickerProviderStateMixin {
  int _oldIndex;

  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _controller.forward(from: 0);
  }

  @override
  void didUpdateWidget(FadeIndexStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.index != oldWidget.index) {
      _oldIndex = oldWidget.index;
      _controller.value = 0;
      _controller.forward().whenComplete(() {
        setState(() {
          _oldIndex = null;
        });
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: widget.alignment,
      textDirection: widget.textDirection,
      fit: widget.fit,
      overflow: widget.overflow,
      children: <Widget>[
        if (_oldIndex != null)
          AnimatedBuilder(
            animation: _controller,
            child: widget.children[_oldIndex],
            builder: (context, child) => Opacity(
              opacity: 1 - _controller.value,
              child: child,
            ),
          ),
        AnimatedBuilder(
          animation: _controller,
          child: widget.children[widget.index],
          builder: (context, child) => Opacity(
            opacity: _controller.value,
            child: child,
          ),
        ),
      ],
    );
  }
}
