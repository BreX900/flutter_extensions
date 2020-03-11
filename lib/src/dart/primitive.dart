import 'dart:convert';

import 'package:rational/rational.dart';
import 'package:basic_utils/basic_utils.dart' as bu;
import 'package:quiver/strings.dart' as qvr;

extension NumExt on num {
  Rational toRational() => Rational.parse(toString());
}

extension StringExt on String {
  /// helloWordGood => HELLO_WORD_GOOD
  String toUpperUnderscore() => bu.StringUtils.camelCaseToUpperUnderscore(this);

  /// hello_word_good => Hello_word_good
  String toUpperFirstCase() => this[0].toUpperCase() + substring(1);

  /// hello_word_good => helloWordGood
  String toCamelCase() {
    return replaceAllMapped(RegExp(r'([_:].)'), (match) {
      return match.group(0)[1].toUpperCase();
    });
  }

  String ifEmpty(String Function() fn) => isEmpty ? fn() : this;

  bool get isBlank => qvr.isBlank(this);

  String ifBlank(String Function() fn) => isBlank ? fn() : this;

  String nullIfEmpty() => isEmpty ? null : this;

  Map<String, dynamic> decodeToMap() => jsonDecode(this) as Map<String, dynamic>;

  List<Map<String, dynamic>> decodeToList() => jsonDecode(this) as List<Map<String, dynamic>>;

  List<String> divide([int startAt = 0, int divideAt, int endAt]) {
    endAt ??= length;
    divideAt ??= endAt ~/ 2;
    return [
      substring(startAt, divideAt),
      substring(divideAt + 1, endAt),
    ];
  }
}
