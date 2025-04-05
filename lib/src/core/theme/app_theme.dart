import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/tools/extensions/extensions.dart';

abstract final class AppTheme {
  static final light = ThemeData(
    brightness: Brightness.light,
    textTheme: GoogleFonts.poppinsTextTheme(),
    colorScheme: lightColorScheme,
    primaryColor: AppColors.blue,
    appBarTheme: const AppBarTheme(
      scrolledUnderElevation: 0,
      elevation: 0,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      circularTrackColor: AppColors.glassBlack,
      linearTrackColor: AppColors.glassBlack,
      color: AppColors.black,
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: Textstyles.normal.copyWith(
        color: AppColors.grey500,
        fontSize: 14.sp,
        height: 1.6,
        fontWeight: FontWeight.w400,
      ),
      contentPadding: REdgeInsets.symmetric(horizontal: 16, vertical: 13),
      border: OutlineInputBorder(
        borderRadius: 8.circularBorder,
        borderSide: const BorderSide(color: AppColors.iGrey500),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: 8.circularBorder,
        borderSide: const BorderSide(color: AppColors.iGrey500),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: 8.circularBorder,
        borderSide: const BorderSide(color: AppColors.iGrey500),
      ),
    ),
  );
}

final lightColorScheme = ColorScheme.light(
  primary: AppColors.blue,
);
