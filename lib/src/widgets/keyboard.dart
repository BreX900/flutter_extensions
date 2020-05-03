import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

//mixin KeyboardVisibilitySoftMixin<W extends StatefulWidget> on State<W> {
//  StreamSubscription _keyboardVisibilitySubscription;
//
//  bool get isKeyboardVisible => KeyboardVisibility.isVisible;
//
//  @override
//  void initState() {
//    super.initState();
//    _keyboardVisibilitySubscription = KeyboardVisibility.onChange.listen(onChangeKeyboardVisibility);
//  }
//
//  @override
//  void dispose() {
//    _keyboardVisibilitySubscription.cancel();
//    super.dispose();
//  }
//
//  void onChangeKeyboardVisibility(bool isKeyboardVisible) {}
//}

mixin KeyboardVisibilityMixin<W extends StatefulWidget> on State<W> {
  StreamSubscription _keyboardVisibilitySubscription;

  bool isKeyboardVisible;

  @override
  void initState() {
    super.initState();
    isKeyboardVisible = KeyboardVisibility.isVisible;
    _keyboardVisibilitySubscription = KeyboardVisibility.onChange.listen(onChangeKeyboardVisibility);
  }

  @override
  void dispose() {
    _keyboardVisibilitySubscription.cancel();
    super.dispose();
  }

  void onChangeKeyboardVisibility(bool isVisible) {
    setState(() {
      isKeyboardVisible = isVisible;
    });
  }
}
