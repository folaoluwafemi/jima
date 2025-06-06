import 'package:jima/src/tools/extensions/extensions.dart';
import 'package:flutter/material.dart';

class EvenlySpacedRow extends StatelessWidget {
  final CrossAxisAlignment? crossAxisAlignment;
  final MainAxisAlignment? mainAxisAlignment;
  final MainAxisSize? mainAxisSize;
  final List<Widget> children;
  final double? spacing;
  final Widget? spacerWidget;

  const EvenlySpacedRow({
    Key? key,
    this.crossAxisAlignment,
    this.mainAxisAlignment,
    this.mainAxisSize,
    required this.children,
    this.spacing,
    this.spacerWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
      mainAxisSize: mainAxisSize ?? MainAxisSize.max,
      children: [
        for (int i = 0; i < children.length; i++) ...[
          if (i != 0) spacerWidget ?? (spacing ?? 0).boxWidth,
          children[i],
        ],
      ],
    );
  }
}
