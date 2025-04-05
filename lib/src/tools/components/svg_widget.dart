import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgWidget extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;
  final AlignmentGeometry alignment;

  const SvgWidget(
    this.path, {
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.color,
    Key? key,
  }) : super(key: key);

  const SvgWidget.square(
    this.path, {
    required double? dimension,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.color,
    Key? key,
  })  : width = dimension,
        height = dimension,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (color == null) {
      return SvgPicture.asset(
        path,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
      );
    }
    return ColorFiltered(
      colorFilter: ColorFilter.mode(color!, BlendMode.srcIn),
      child: SvgPicture.asset(
        path,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
      ),
    );
  }
}
