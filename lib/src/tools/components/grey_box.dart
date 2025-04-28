import 'package:flutter/material.dart';
import 'package:jima/src/core/core.dart';
import 'package:jima/src/tools/extensions/extensions.dart';

class GreyBox extends StatelessWidget {
  final Color? color;
  final double? height;
  final double? width;
  final double? radius;
  final BorderRadius? borderRadius;
  final EdgeInsets? margin;

  const GreyBox({
    this.color,
    this.width,
    this.height,
    this.radius,
    this.margin,
    this.borderRadius,
    super.key,
  });

  const GreyBox.square({
    required double dimension,
    this.color,
    this.radius,
    this.borderRadius,
    this.margin,
    super.key,
  })  : height = dimension,
        width = dimension;

  GreyBox.circle({
    required double dimension,
    this.color,
    this.radius,
    this.margin,
    super.key,
  })  : height = dimension,
        borderRadius = 100000.circularBorder,
        width = dimension;

  const GreyBox.boxEdge({
    this.color,
    this.height,
    this.width,
    this.radius = 0,
    this.borderRadius,
    this.margin,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color ?? AppColors.iGrey500,
        borderRadius: borderRadius ?? (radius ?? 4).circularBorder,
      ),
    );
  }
}
