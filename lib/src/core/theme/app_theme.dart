import 'package:flutter/material.dart';

abstract final class AppTheme {
  static final light = ThemeData.light().copyWith(
    colorScheme: lightColorScheme,
  );
}

final lightColorScheme = ColorScheme.light();
