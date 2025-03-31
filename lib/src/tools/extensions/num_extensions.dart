import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension NumExtension on num {
  ///returns value * (percentage/100)
  double percent(num percentage) => this * (percentage / 100);

  num? get nullIfZero => this == 0 ? null : this;

  double get negate => this * -1;

  String get resolvePlurality => this == 1 ? '' : 's';

  String get resolveVowelPlurality => this == 1 ? '' : 'es';

  double ratio(double value) => this * value;

  double get toRadians => this * (math.pi / 180);

  double get toDegrees => this / (math.pi * 180);

  double get pi => this * math.pi;

  double get degreesToPi => this * (180 / math.pi);

  String get moneyText => '\u20A6${commaFormatted()}';

  String commaFormatted() {
    return toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  BorderRadius get bottomCorner => BorderRadius.only(
        topRight: Radius.circular(toDouble()),
        bottomRight: Radius.circular(toDouble()),
        topLeft: Radius.circular(toDouble()),
      );

  BorderRadius get circularBorder => BorderRadius.all(
        Radius.circular(toDouble()),
      );

  BorderRadius get circularBorderTop => BorderRadius.vertical(
        top: Radius.circular(toDouble()),
      );

  BorderRadius get circularBorderBottom => BorderRadius.vertical(
        bottom: Radius.circular(toDouble()),
      );

  BorderRadius get circularBorderLeft => BorderRadius.horizontal(
        left: Radius.circular(toDouble()),
      );

  BorderRadius get circularBorderRight => BorderRadius.horizontal(
        right: Radius.circular(toDouble()),
      );

  SizedBox get boxHeight => SizedBox(height: h);

  Widget get sliverBoxHeight => SliverToBoxAdapter(child: SizedBox(height: h));

  Widget get sliverBoxWidth => SliverToBoxAdapter(child: SizedBox(width: w));

  SizedBox get boxWidth => SizedBox(width: w);
}

extension IntExtension on int {
  List<int> range([int start = 1]) => List<int>.generate(
        this,
        (int index) => index + start,
      );

  Duration get seconds => Duration(seconds: this);

  bool get isSingleDigit => this > -1 && this <= 9;

  double percent(double value) => this * value / 100;

  double ratio(double value) => this * value;

  double get toRadians => this * (math.pi / 180);

  double get pi => this * math.pi;

  String toOrdinal() {
    final number = toInt();
    final remainder = number % 100;

    if (remainder >= 11 && remainder <= 13) {
      return '${number}th';
    }

    switch (number % 10) {
      case 1:
        return '${number}st';
      case 2:
        return '${number}nd';
      case 3:
        return '${number}rd';
      default:
        return '${number}th';
    }
  }
}
