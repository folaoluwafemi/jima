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
  final bool loading;

  const AppButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.textStyle,
    this.padding,
    this.textColor,
    this.color,
    this.borderColor,
    this.icon,
    this.loading = false,
  });

  const AppButton.primary({
    required this.onPressed,
    required this.text,
    this.textStyle,
    this.padding,
    this.borderColor,
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
    this.icon,
    super.key,
    this.loading = false,
  })  : color = AppColors.glassBlack,
        borderColor = AppColors.blue,
        textColor = AppColors.white;

  const AppButton.text({
    required this.onPressed,
    required this.text,
    this.textStyle,
    this.padding,
    this.borderColor,
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
        borderRadius: 8.circularBorder,
        side: borderColor == null
            ? BorderSide.none
            : BorderSide(
                color: borderColor!,
                width: 2.sp,
              ),
      ),
      highlightElevation: 0,
      elevation: 0,
      child: Padding(
        padding: REdgeInsets.symmetric(vertical: 16.h),
        child: Row(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
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
