import 'package:flutter/material.dart';

extension BuildContextEx on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;

  ThemeData get theme => Theme.of(this);

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  EdgeInsets get viewPadding => MediaQuery.viewPaddingOf(this);

  double get bottomScreenPadding => MediaQuery.viewPaddingOf(this).bottom;

  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);

  double screenHeight({
    double percent = 1,
  }) =>
      MediaQuery.of(this).size.height * percent;

  double screenWidth({
    double percent = 1,
  }) =>
      MediaQuery.of(this).size.width * percent;

  double get height => MediaQuery.sizeOf(this).height;

  double get width => MediaQuery.sizeOf(this).width;

  void hideKeyboard() {
    FocusScope.of(this).unfocus();
  }
}
