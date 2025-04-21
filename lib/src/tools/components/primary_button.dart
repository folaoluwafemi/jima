import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/tools/extensions/extensions.dart';

class AppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Widget? icon;
  final TextStyle? textStyle;
  final EdgeInsets? padding;
  final Color? textColor;
  final Color? color;
  final Color? borderColor;
  final BorderRadius? borderRadius;
  final bool loading;
  final double? borderWidth;
  final MainAxisAlignment? mainAxisAlignment;

  const AppButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.textStyle,
    this.padding,
    this.textColor,
    this.color,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.icon,
    this.mainAxisAlignment,
    this.loading = false,
  });

  const AppButton.primary({
    required this.onPressed,
    required this.text,
    this.textStyle,
    this.padding,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.mainAxisAlignment,
    this.icon,
    super.key,
    this.loading = false,
  })  : color = AppColors.blue,
        textColor = AppColors.white;

  const AppButton.white({
    required this.onPressed,
    required this.text,
    this.textStyle,
    this.padding,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.mainAxisAlignment,
    this.icon,
    super.key,
    this.loading = false,
  })  : color = AppColors.white,
        textColor = AppColors.buttonTextBlack;

  const AppButton.outlined({
    required this.onPressed,
    required this.text,
    this.textStyle,
    this.padding,
    this.borderWidth,
    this.borderRadius,
    this.mainAxisAlignment,
    Color? borderColor,
    Color? color,
    Color? textColor,
    this.icon,
    super.key,
    this.loading = false,
  })  : color = color ?? AppColors.glassBlack,
        borderColor = borderColor ?? AppColors.blue,
        textColor = textColor ?? AppColors.white;

  const AppButton.text({
    required this.onPressed,
    required this.text,
    this.textStyle,
    this.padding,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.mainAxisAlignment,
    this.icon,
    super.key,
    this.loading = false,
  })  : color = Colors.transparent,
        textColor = AppColors.blue;

  @override
  Widget build(BuildContext context) {
    final style = textStyle ??
        GoogleFonts.poppins(
          fontSize: 16.sp,
          height: 1.5,
          color: textColor,
          fontWeight: FontWeight.w700,
        );
    return RawMaterialButton(
      onPressed: onPressed,
      fillColor: onPressed == null ? AppColors.buttonDisabled : color,
      disabledElevation: 0,
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? 8.circularBorder,
        side: borderColor == null
            ? BorderSide.none
            : BorderSide(
                color: borderColor!,
                width: borderWidth ?? 2.sp,
              ),
      ),
      highlightElevation: 0,
      elevation: 0,
      child: Padding(
        padding: padding ?? REdgeInsets.symmetric(vertical: 16.h),
        child: Row(
          mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
          children: [
            if (!loading) ...[
              if (icon != null) ...[
                icon!,
                8.boxWidth,
              ],
              Text(text, style: style),
            ] else
              SizedBox.square(
                dimension: 21.h,
                child: const CircularProgressIndicator(
                  strokeWidth: 3,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation(AppColors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
