import 'package:flutter/material.dart';
import '../dart/primitive.dart';

extension DateTimeExtFlutter on DateTime {
  TimeOfDay toTimeOfDay(DateTime dateTime) => TimeOfDay.fromDateTime(dateTime);

  DateTime copyWithTimeOfDay(TimeOfDay timeOfDay) {
    return copyWith(hour: timeOfDay.hour, minute: timeOfDay.minute);
  }
}
