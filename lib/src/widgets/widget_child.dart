import 'package:flutter/widgets.dart';

/// Beta
mixin NestedChild {
  Widget build(BuildContext context) => buildWithChild(context, Builder(builder: buildChild));

  Widget buildWithChild(BuildContext context, Widget child) => child;

  Widget buildChild(BuildContext context);
}

/// Beta
abstract class NestedStatelessWidget extends StatelessWidget with NestedChild {}

/// Beta
abstract class NestedState<W extends StatefulWidget> extends State<W> with NestedChild {}
