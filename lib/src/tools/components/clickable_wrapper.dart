import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/tools/extensions/extensions.dart';

class ClickableWrapper extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final TextStyle? textStyle;
  final EdgeInsets? padding;
  final Color? color;

  const ClickableWrapper({
    super.key,
    required this.onPressed,
    required this.child,
    this.textStyle,
    this.padding,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final style = textStyle ??
        TextStyle(
          fontSize: 17.sp,
          height: 1,
          color: AppColors.blue,
        );
    return DefaultTextStyle(
      style: style,
      child: RawMaterialButton(
        onPressed: onPressed,
        fillColor: onPressed == null ? AppColors.buttonDisabled : color,
        disabledElevation: 0,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: 37.circularBorder,
        ),
        highlightElevation: 0,
        elevation: 0,
        child: Padding(
          padding: REdgeInsets.symmetric(vertical: 21.5.h),
          child: child,
        ),
      ),
    );
  }
}
