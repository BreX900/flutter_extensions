import 'dart:convert';
import 'dart:math' as math;

import 'package:rational/rational.dart';
import 'package:basic_utils/basic_utils.dart' as bu;
import 'package:quiver/strings.dart' as qvr;

extension NumExtDart on num {
  Rational toRational() => Rational.parse(toString());

  num min(num other) => math.min<num>(this, other);
  num pow(num exponent) => math.pow(this, exponent);
  double sin() => math.sin(this);
  double cos() => math.cos(this);
  double tan() => math.tan(this);
  double acos() => math.acos(this);
  double asin() => math.asin(this);
  double atan() => math.atan(this);
  double sqrt() => math.sqrt(this);
  double exp() => math.exp(this);
  double log() => math.log(this);
}

extension doubleExtDart on double {
  Rational toRational() => Rational.parse(toString());

  double min(double other) => math.min<double>(this, other);
  double max(double other) => math.max<double>(this, other);
}

extension intExtDart on int {
  Rational toRational() => Rational.fromInt(this);

  int min(int other) => math.min<int>(this, other);
  int max(int other) => math.max<int>(this, other);
}

extension StringExtDart on String {
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

  String advSubString(int start, [int end]) {
    if (start < 0) start += length;
    return substring(start, end != null ? (end < 0 ? length + end : end) : null);
  }

  String trimBy(String trimmer) {
    var string = this;
    while (string.startsWith(trimmer)) {
      string = string.substring(0, trimmer.length);
    }
    while (string.endsWith(trimmer)) {
      string = string.advSubString(0, -trimmer.length);
    }
    return string;
  }

  String joinPath(String path) => '${trimBy('/')}/${path.trimBy('/')}';

  String joinPaths(Iterable<String> paths) {
    return '${trimBy('/')}/${paths.map((e) => e.trimBy('/')).join('/')}';
  }

  Rational toRational() => Rational.parse(this);
  Rational tryToRational() {
    try {
      return Rational.parse(this);
    } catch (_) {
      return null;
    }
  }
}

extension DateTimeExtDart on DateTime {
  DateTime copyWith({
    int year,
    int month,
    int hour,
    int day,
    int minute,
    int second,
    int millisecond,
    int microsecond,
  }) {
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }

  DateTime copyWithPosition({int leading, int middle, int trailing}) {
    return copyWith(
      year: leading,
      month: leading,
      day: leading,
      hour: middle,
      minute: middle,
      second: middle,
      millisecond: trailing,
      microsecond: trailing,
    );
  }
}
