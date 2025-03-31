import 'package:jima/src/tools/tools_barrel.dart';

typedef Mapper<T, E> = E Function(T item);

abstract final class ParseUtils {
  static E parseEnum<E extends Enum>(String? value, List<E> values) {
    try {
      return values.firstWhere(
        (element) => (element as dynamic).enumValue == value,
      );
    } catch (e) {
      throw ArgumentError('Invalid value: $value--$e');
    }
  }

  static E? maybeParseEnum<E extends Enum>(String? value, List<E> values) {
    try {
      return values.firstWhereOrNull(
        (element) => (element as dynamic).enumValue == value,
      );
    } catch (e) {
      return null;
    }
  }

  static E parseJson<E>(
    Object? data, {
    required Mapper<Map<String, Object?>, E> mapper,
  }) {
    return data.parseJson(mapper);
  }

  static E? maybeParseJson<E>(
    Object? data, {
    required Mapper<Map<String, Object?>, E> mapper,
  }) {
    try {
      return data.parseJson(mapper);
    } catch (e) {
      return null;
    }
  }

  static bool parseBool(Object? data) => data.parseBool();

  static bool? maybeParseBool(Object? data) => data.maybeParseBool();

  static String parseString(Object? data) => data.parseString();

  static String? maybeParseString(Object? data) => data.maybeParseString();

  static DateTime parseDateTime(Object? data) => data.parseDateTime();

  static Map<String, Object?> deepJsonCast(Object? data) => data.deepJsonCast();

  static List<E> deepArrayCast<E>(Object? data) => data.deepArrayCast();

  static List<E> parseArray<E, T>(
    T data, {
    required Mapper<T, E> mapper,
  }) =>
      data.parseArray(mapper);

  static List<E> parseMapArray<E>(
    Object? data, {
    required Mapper<Map<String, Object?>, E> mapper,
  }) =>
      data.parseMapArray(mapper);

  static DateTime? maybeParseDateTime(
    Object? data,
  ) =>
      data.maybeParseDateTime();

  static double parseDouble(Object? data) => data.parseDouble();

  static int parseInt(Object? data) => data.parseInt();

  static int? maybeParseInt(
    Object? data, [
    int defaultValue = 0,
  ]) =>
      data.maybeParseInt();

  static double? maybeParseDouble(
    Object? data, [
    double defaultValue = 0,
  ]) =>
      data.maybeParseDouble();

  static T parseNumber<T extends num>(
    Object? data,
  ) =>
      data.parseNumber();

  static T? maybeParseNumber<T extends num>(Object? data, [T? defaultValue]) =>
      data.maybeParseNumber();
}

extension _GenericExtension<T extends Object?> on T {
  E parseJson<E>(
    Mapper<Map<String, Object?>, E> mapper,
  ) {
    return mapper(deepJsonCast());
  }

  bool parseBool() => bool.parse(parseString());

  bool? maybeParseBool() => bool.tryParse(parseString());

  String parseString() => this == null ? '' : toString();

  String? maybeParseString() {
    return (this == null || this == 'null') ? null : toString();
  }

  DateTime parseDateTime() => maybeParseDateTime()!;

  Map<String, Object?> deepJsonCast() => (this as Map).cast<String, Object?>();

  List<E> deepArrayCast<E>() => (this as List? ?? []).cast();

  List<E> parseArray<E>(Mapper<T, E> mapper) {
    return (this as List? ?? []).map<E>((e) {
      return mapper(e);
    }).toList();
  }

  List<E> parseMapArray<E>(Mapper<Map<String, Object?>, E> mapper) {
    return (this as List? ?? []).cast<Map>().map<E>((Map e) {
      return mapper(e.deepJsonCast());
    }).toList();
  }

  DateTime? maybeParseDateTime() {
    final data = this;
    try {
      if (data == null) return null;
      if (data is DateTime) return data.toLocal();
      return DateTime.parse(data.toString()).toLocal();
    } on FormatException {
      if (data is DateTime) return data.toLocal();
      if (data is String) {
        return DateTime.fromMillisecondsSinceEpoch(int.parse(data)).toLocal();
      }
      return DateTime.fromMillisecondsSinceEpoch(data as int).toLocal();
    } catch (e) {
      return null;
    }
  }

  double parseDouble() => (this as num).toDouble();

  int parseInt() =>
      (this is String ? num.parse((this as String)) : (this as num)).toInt();

  int? maybeParseInt([
    int defaultValue = 0,
  ]) {
    return (this as num?)?.toInt() ?? defaultValue;
  }

  double? maybeParseDouble([double defaultValue = 0]) {
    return (this as num?)?.toDouble() ?? defaultValue;
  }

  Number parseNumber<Number extends num>() => this as Number;

  Number? maybeParseNumber<Number extends num>([
    Number? defaultValue,
  ]) {
    return (this as Number?) ?? defaultValue;
  }
}
