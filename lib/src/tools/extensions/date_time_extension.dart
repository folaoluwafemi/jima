import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  DateTime copyAdd({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
  }) =>
      DateTime(
        (year ?? 0) + this.year,
        (month ?? 0) + this.month,
        (day ?? 0) + this.day,
        (hour ?? 0) + this.hour,
        (minute ?? 0) + this.minute,
        (second ?? 0) + this.second,
      );

  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) =>
      DateTime(
        year ?? this.year,
        month ?? this.month,
        day ?? this.day,
        hour ?? this.hour,
        minute ?? this.minute,
        second ?? this.second,
        millisecond ?? this.millisecond,
        microsecond ?? this.microsecond,
      );

  DateTime copyAsDate() => DateTime(year, month, day);

  DateTime copySubtract({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
  }) =>
      DateTime(
        this.year - (year ?? 0),
        this.month - (month ?? 0),
        this.day - (day ?? 0),
        this.hour - (hour ?? 0),
        this.minute - (minute ?? 0),
        this.second - (second ?? 0),
      );

  int get secondsSinceEpoch => millisecondsSinceEpoch ~/ 1000;

  String dateText({String separator = '/'}) {
    return toString()
        .split(' ')
        .first
        .trim()
        .split('-')
        .reversed
        .join(separator)
        .trim();
  }
}
