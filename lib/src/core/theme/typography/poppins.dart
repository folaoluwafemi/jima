import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class Typography {
  static final double _defaultSize = 14.sp;
  static const Color _defaultColor = Colors.black;

  static final light = GoogleFonts.poppins(
    fontWeight: FontWeight.w300,
    fontSize: _defaultSize,
    color: _defaultColor,
  );
  static final normal = GoogleFonts.poppins(
    fontWeight: FontWeight.w400,
    fontSize: _defaultSize,
    color: _defaultColor,
  );
  static final medium = GoogleFonts.poppins(
    fontWeight: FontWeight.w500,
    fontSize: _defaultSize,
    color: _defaultColor,
  );
  static final semibold = GoogleFonts.poppins(
    fontWeight: FontWeight.w600,
    fontSize: _defaultSize,
    color: _defaultColor,
  );
  static final bold = GoogleFonts.poppins(
    fontWeight: FontWeight.w700,
    fontSize: _defaultSize,
    color: _defaultColor,
  );
}

asa() {
  GoogleFonts.poppins();
}
