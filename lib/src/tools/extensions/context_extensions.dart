import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

extension BuildContextEx on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;

  ThemeData get theme => Theme.of(this);

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  Color get scaffoldBackgroundColor => Theme.of(this).scaffoldBackgroundColor;

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

  void showErrorToast(String message) {
    toastification.show(
      context: this, // optional if you use ToastificationWrapper
      title: Text(message),
      type: ToastificationType.error,
      autoCloseDuration: const Duration(seconds: 5),
    );
  }

  void showSuccessToast(String message) {
    toastification.show(
      context: this, // optional if you use ToastificationWrapper
      title: Text(message),
      type: ToastificationType.success,
      autoCloseDuration: const Duration(seconds: 5),
    );
  }

  void showInfoToast(String message) {
    toastification.show(
      context: this, // optional if you use ToastificationWrapper
      title: Text(message),
      type: ToastificationType.info,
      autoCloseDuration: const Duration(seconds: 5),
    );
  }
}
