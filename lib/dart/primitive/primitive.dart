import 'dart:convert';

import 'package:rational/rational.dart';
import 'package:basic_utils/basic_utils.dart' as bu;

extension NumExt on num {
  Rational toRational() => Rational.parse(toString());
}

extension StringExt on String {
  String get camelCaseToUpperUnderscore => bu.StringUtils.camelCaseToUpperUnderscore(this);

  T deserialize<T>() => jsonDecode(this) as T;
}
